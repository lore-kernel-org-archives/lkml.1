Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbYHNGsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbYHNGsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757761AbYHNGmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:42:21 -0400
Received: from orca.ele.uri.edu ([131.128.51.63]:45519 "EHLO orca.ele.uri.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833AbYHNGmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:42:19 -0400
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Aug 2008 02:42:19 EDT
Date: Thu, 14 Aug 2008 02:26:22 -0400
From: Will Simoneau <simoneau@ele.uri.edu>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>
Subject: Re: [ANNOUNCE] Wifi Link 5300 and 5100 Series
Message-ID: <20080814062604.GA16234@ele.uri.edu>
References: <1ba2fa240808131411o638311f1m2e2daa6ef62057b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <1ba2fa240808131411o638311f1m2e2daa6ef62057b1@mail.gmail.com>
User-Agent: Mutt/1.5.16 [Linux 2.6.27-rc2-wl x86_64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 00:11 Thu 14 Aug     , Tomas Winkler wrote:
> Intel would like to announce Linux support  for Wifi Link 5000 and
> 5100 Series Adapters under iwlwifi driver (iwlagn.ko)
>=20
=2E..
> The best known working driver can be located in iwl500 branch of
> iwlwifi-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git iwl=
5000

This is great news to me - my new Sager laptop has a 5300 card. However,
it doesn't seem to work:

iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
iwlagn: Copyright(c) 2003-2008 Intel Corporation
iwlagn 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:07:00.0: setting latency timer to 64
iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=3D0x24
iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
phy7: Selected rate control algorithm 'iwl-agn-rs'
iwlagn 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
firmware: requesting iwlwifi-5000-1.ucode
iwlagn 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn: START_ALIVE timeout after 4000ms.

I have the microcode in /lib/firmware, and the kernel/driver source is
the latest from iwlwifi-2.6.git. What else should I provide for
debugging?

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkij0A0ACgkQLYBaX8VDLLWBBQCgpSE8SuS3KkGLu4mTq6S/WwoA
ZEMAn1eczr++35/evLydig3tJt2Z5k2S
=sDKP
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
