Return-Path: <linux-kernel-owner+w=401wt.eu-S934634AbXHYUOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634AbXHYUOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 16:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934263AbXHYUOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 16:14:39 -0400
Received: from kolab.mylinuxtime.de ([212.112.242.22]:51339 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934238AbXHYUOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 16:14:38 -0400
X-Spam-ASN: 
From: Christian Hesse <mail@earthworm.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Suspend2-devel] Problem with CFS V20 and Suspend2/tuxonice
Date: Sat, 25 Aug 2007 22:14:22 +0200
User-Agent: KMail/1.9.7
Cc: suspend2-devel@lists.tuxonice.net, Fabio Comolli <fabio.comolli@gmail.com>,
       linux-kernel@vger.kernel.org, Suspend2-users@lists.suspend2.net,
       suspend2-devel <suspend2-devel@lists.suspend2.net>,
       David Rodriguez <livuxman@gmail.com>
References: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com> <200708251852.28698.mail@earthworm.de> <20070825190205.GB15888@elte.hu>
In-Reply-To: <20070825190205.GB15888@elte.hu>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1353628.JZp7TIcT3D";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708252214.27497.mail@earthworm.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1353628.JZp7TIcT3D
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 25 August 2007, Ingo Molnar wrote:
> * Christian Hesse <mail@earthworm.de> wrote:
> > > Reproduced on a Intel Centrino based laptop with gentoo kamikaze7
> > > sources (http://forums.gentoo.org/viewtopic-t-577970.html)
> >
> > Same problem here: Core Duo, Kernel 2.6.22.5, Suspend 2.2.10, CFS v20.2.
>
> please try the patch below - does it fix the problem?

Works for me. Thanks a lot!
=2D-=20
Regards,
Chris

--nextPart1353628.JZp7TIcT3D
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBG0I2elZfG2c8gdSURAve+AJ9pvnPQSBV+sqCHQXcYFNYzWCbyawCg7dYB
ZxAJYHwPWg6VpL6+UGQaV6I=
=ujGM
-----END PGP SIGNATURE-----

--nextPart1353628.JZp7TIcT3D--
