--星騎士 セイクリッド・カドケウス
--Script by 奥克斯
function c101112045.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	Duel.EnableGlobalFlag(GLOBALFLAG_XMAT_COUNT_LIMIT)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112045,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101112045)
	e1:SetCondition(c101112045.thcon)
	e1:SetTarget(c101112045.thtg)
	e1:SetOperation(c101112045.thop)
	c:RegisterEffect(e1)
	--star_knight_summon_effect_copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112045,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101112045+100)
	e2:SetTarget(c101112045.copytg)
	e2:SetOperation(c101112045.copyop)
	c:RegisterEffect(e2)
end
function c101112045.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c101112045.thfilter(c,e)
	return c:IsSetCard(0x9c,0x53) and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c101112045.fselect(g)
	if #g==1 then return true end
	return aux.gfcheck(g,Card.IsSetCard,0x9c,0x53)
end
function c101112045.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101112045.thfilter(chkc,e) end
	local g=Duel.GetMatchingGroup(c101112045.thfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,c101112045.fselect,false,1,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101112045.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if #tg==0 then return end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
function c101112045.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x9c,0x53) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()) then return false end
	local te=c.star_knight_summon_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,nil,c)
end
function c101112045.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return e:IsCostChecked() and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
			and Duel.IsExistingMatchingCard(c101112045.efffilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101112045.efffilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local tc=g:GetFirst()
	Duel.ClearTargetCard()
	e:SetLabelObject(tc)
	local te=tc.star_knight_summon_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end
function c101112045.copyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local te=tc.star_knight_summon_effect
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
