Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbYHNTOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbYHNTOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbYHNTOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:14:10 -0400
Received: from orca.ele.uri.edu ([131.128.51.63]:44093 "EHLO orca.ele.uri.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbYHNTOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:14:08 -0400
Date: Thu, 14 Aug 2008 15:13:47 -0400
From: Will Simoneau <simoneau@ele.uri.edu>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>
Subject: Re: [ANNOUNCE] Wifi Link 5300 and 5100 Series
Message-ID: <20080814191347.GA9662@ele.uri.edu>
References: <1ba2fa240808131411o638311f1m2e2daa6ef62057b1@mail.gmail.com> <20080814062604.GA16234@ele.uri.edu> <1ba2fa240808140515r92a3ec7i90ea6c03e2adb7ee@mail.gmail.com> <1ba2fa240808140603p3b4a47e4k4a0b98e5bf145b57@mail.gmail.com> <20080814175532.GB30317@ele.uri.edu> <1ba2fa240808141109l11d729ecjf6253e9acf5d3c7f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <1ba2fa240808141109l11d729ecjf6253e9acf5d3c7f@mail.gmail.com>
User-Agent: Mutt/1.5.16 [Linux 2.6.26-rc6-iwl-2.3.5-wl x86_64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21:09 Thu 14 Aug     , Tomas Winkler wrote:
> On Thu, Aug 14, 2008 at 8:55 PM, Will Simoneau <simoneau@ele.uri.edu> wro=
te:
> > On 16:03 Thu 14 Aug     , Tomas Winkler wrote:
> >> On Thu, Aug 14, 2008 at 3:15 PM, Tomas Winkler <tomasw@gmail.com> wrot=
e:
> >> > On Thu, Aug 14, 2008 at 9:26 AM, Will Simoneau <simoneau@ele.uri.edu=
> wrote:
> >> >> On 00:11 Thu 14 Aug     , Tomas Winkler wrote:
> >> >>> Intel would like to announce Linux support  for Wifi Link 5000 and
> >> >>> 5100 Series Adapters under iwlwifi driver (iwlagn.ko)
> >> >>>
> >> >> ...
> >> >>> The best known working driver can be located in iwl500 branch of
> >> >>> iwlwifi-2.6.git
> >> >>> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.=
git iwl5000
> >> >>
> >> >> This is great news to me - my new Sager laptop has a 5300 card. How=
ever,
> >> >> it doesn't seem to work:
> >> >>
> >>
> >> Can you send me the exact laptop type?
> >> Thanks
> >
> > It's a Sager NP5796 (Clevo M570TU).
> >
>=20
> >git-checkout -b iwl5000 origin/iwl5000
> Tomas

OK, that gave me very different kernel/driver versions.
uname -r: 2.6.26-rc6-iwl-2.3.5-wl

dmesg:

iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 2.3.5ks
iwlagn: Copyright(c) 2003-2008 Intel Corporation
ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:07:00.0 to 64
iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=3D0x24
iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
phy1: Selected rate control algorithm 'iwl-agn-rs'
input: 5300AGN as /class/input/input7
ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 17 (level, low) -> IRQ 17
firmware: requesting iwlwifi-5000-1.ucode
iwlagn: START_ALIVE timeout after 4000ms.

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkikg+sACgkQLYBaX8VDLLWfvACfax5OUR2V8dmwOwKXzvvk53ir
2c4An1CBPzYAl+Yw584HYX+q+v8/5qLN
=/hdj
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
