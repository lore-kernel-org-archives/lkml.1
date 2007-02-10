Return-Path: <linux-kernel-owner+w=401wt.eu-S1750979AbXBJNkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbXBJNkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 08:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbXBJNkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 08:40:52 -0500
Received: from lugor.de ([212.112.242.222]:48192 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750979AbXBJNku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 08:40:50 -0500
X-Greylist: delayed 997 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Feb 2007 08:40:50 EST
From: "Hesse, Christian" <mail@earthworm.de>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Date: Sat, 10 Feb 2007 14:23:55 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
References: <45CCE3CA.4050904@linux.intel.com>
In-Reply-To: <45CCE3CA.4050904@linux.intel.com>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1331304.FZbrcmnoEp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702101424.00156.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Sat, 10 Feb 2007 14:23:53 +0100 (CET)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1331304.FZbrcmnoEp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 09 February 2007 22:12, James Ketrenos wrote:
> We are pleased to announce the availability of a new driver for the
> Intel PRO/Wireless 3945ABG Network Connection adapter.

Wow, great news on this rainy saturday! ;-)

The driver works perfectly, I'm writing this mail via wireless link. Howeve=
r=20
there are two things to note:

The driver generates two network devices. The second one is for promicious=
=20
mode? Is there any chance to disable the interface? ifrename renamed the=20
wrong one to wlan0 and I had to tell my system to use eth1 for the wireless=
=20
connection.

Second problem is that I can't unload the module. I get the message "FATAL:=
=20
Module iwlwifi is in use." even if both interfaces are down.
=2D-=20
Regards,
Chris

--nextPart1331304.FZbrcmnoEp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFzcdwlZfG2c8gdSURAvfiAJ4nWHv3+Jz4m+AJbHwUN3VVmqOmoQCgktqe
rgsCSbzhtU3sd2uTVluX1K8=
=T5s0
-----END PGP SIGNATURE-----

--nextPart1331304.FZbrcmnoEp--
