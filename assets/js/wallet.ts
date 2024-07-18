import { Cosmiframe } from "@dao-dao/cosmiframe";

const CHAIN_ID = "kaiyo-1";

const cosmiframe = new Cosmiframe([
  "https://daodao.zone",
  "https://dao.daodao.zone",
]);
console.log(cosmiframe);

export const connect = async (): Promise<any> => {
  console.log("connect");

  console.log(await cosmiframe.isReady());

  if (!(await cosmiframe.isReady())) {
    throw new Error("DAO DAO Cosmiframe not ready");
  }

  return cosmiframe.p
    .connect(CHAIN_ID)
    .then(() => cosmiframe.p.getAccount(CHAIN_ID));
};
export const signAndBroadcast = async (rpc: string, address: string, msgs) => {
  const signer = cosmiframe.getOfflineSigner(CHAIN_ID);

  return signer.signDirect(address, msgs);
};

export const hook = {
  mounted() {
    console.log("mounted");

    connect().then((res) => {
      console.log(res);

      this.pushEvent("dao-connected", res);
    });
  },
};
