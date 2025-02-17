--烙印の即凶劇
--Script by 奥克斯
function c101112071.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112071,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,101112071)
	e1:SetTarget(c101112071.sctg)
	e1:SetOperation(c101112071.scop)
	c:RegisterEffect(e1)
	--macro cosmos
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0xfe,0xff)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetCondition(c101112071.rmcon)
	e2:SetTarget(c101112071.rmtg)
	c:RegisterEffect(e2)
end
function c101112071.mfilter(c)
	return c:IsRace(RACE_DRAGON)
end
function c101112071.mfilter2(c)
	return c:IsHasEffect(EFFECT_HAND_SYNCHRO) and c:IsType(TYPE_MONSTER)
end
function c101112071.cfilter(c,syn)
	local b1=true
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		b1=Duel.CheckTunerMaterial(syn,c,nil,c101112071.mfilter,1,99)
	end
	return b1 and syn:IsSynchroSummonable(c)
end
function c101112071.spfilter(c,mg)
	return mg:IsExists(c101112071.cfilter,1,nil,c)
end
function c101112071.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101112071.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c101112071.mfilter,tp,LOCATION_MZONE,0,nil)
		local exg=Duel.GetMatchingGroup(c101112071.mfilter2,tp,LOCATION_MZONE,0,nil)
		mg:Merge(exg)
		return Duel.IsExistingMatchingCard(c101112071.spfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101112071.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c101112071.mfilter,tp,LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(c101112071.mfilter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(exg)
	local g=Duel.GetMatchingGroup(c101112071.spfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:FilterSelect(tp,c101112071.cfilter,1,1,nil,sg:GetFirst())
		Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
	end
end
function c101112071.rmcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,1,nil,0x188)
end
function c101112071.rmtg(e,c)
	local tp=e:GetHandlerPlayer()
	local b1=c:IsReason(REASON_RITUAL) and c:IsReason(REASON_RELEASE)
	local b2=c:IsReason(REASON_FUSION+REASON_SYNCHRO+REASON_LINK)
	return c:GetOwner()==1-tp and c:GetReasonPlayer()==1-tp and (b1 or b2)
end
