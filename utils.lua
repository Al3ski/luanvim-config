local M = {}

function M.copyTable(datatable)
  local tblRes = {}
  if type(datatable) == "table" then
    for k, v in pairs(datatable) do
      tblRes[M.copyTable(k)] = M.copyTable(v)
    end
  else
    tblRes = datatable
  end
  return tblRes
end

return M
