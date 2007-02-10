Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbXBJO0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbXBJO0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 09:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXBJO0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 09:26:00 -0500
Received: from lugor.de ([212.112.242.222]:57227 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932300AbXBJOZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 09:25:58 -0500
From: "Hesse, Christian" <mail@earthworm.de>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Date: Sat, 10 Feb 2007 15:25:48 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
References: <45CCE3CA.4050904@linux.intel.com> <200702101424.00156.mail@earthworm.de>
In-Reply-To: <200702101424.00156.mail@earthworm.de>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4019170.1c3ci8dBOU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702101525.56820.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Sat, 10 Feb 2007 15:25:50 +0100 (CET)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4019170.1c3ci8dBOU
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 10 February 2007 14:23, Hesse, Christian wrote:
> On Friday 09 February 2007 22:12, James Ketrenos wrote:
> > We are pleased to announce the availability of a new driver for the
> > Intel PRO/Wireless 3945ABG Network Connection adapter.
>
> Wow, great news on this rainy saturday! ;-)
>
> The driver works perfectly, I'm writing this mail via wireless link.
> However there are two things to note:
>
> The driver generates two network devices. The second one is for promicious
> mode? Is there any chance to disable the interface? ifrename renamed the
> wrong one to wlan0 and I had to tell my system to use eth1 for the wirele=
ss
> connection.
>
> Second problem is that I can't unload the module. I get the message "FATA=
L:
> Module iwlwifi is in use." even if both interfaces are down.

Oh, I forgot one note: "make patch_kernel" is terribly broken. Any chance t=
o=20
get this fixed soon?
=2D-=20
Regards,
Chris

--nextPart4019170.1c3ci8dBOU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFzdX0lZfG2c8gdSURArNvAKDqpZwP8EkjphorY1tka+GEmFYKJQCgv8Bp
+nNB/GDp0HYCL9nwxjnxupk=
=Gd7L
-----END PGP SIGNATURE-----

--nextPart4019170.1c3ci8dBOU--
