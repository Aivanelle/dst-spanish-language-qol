local Grammar = Class(function(self, inst)
  self.inst = inst
  self.savegrammar = false
  self.grammaticalnumber = nil
  self.gender = nil
end)

function Grammar:SetGrammaticalNumber(grammaticalNumber)
  self.grammaticalnumber = grammaticalNumber
end

function Grammar:SetGender(gender)
  self.gender = gender
end

function Grammar:SetOnSave(bool)
  self.savegrammar = bool ~= nil and bool or false
end

function Grammar:OnSave()
  if not self.savegrammar then return end

  local data = {}

  if self.grammaticalnumber then
    data.grammaticalnumber = self.grammaticalnumber
  end

  if self.gender then
    data.gender = self.gender
  end

  return data
end

function Grammar:OnLoad(data)
  if not data then return end

  if data.grammaticalnumber then
    self:SetGrammaticalNumber(data.grammaticalnumber)
  end

  if data.gender then
    self:SetGender(data.gender)
  end
end

return Grammar
