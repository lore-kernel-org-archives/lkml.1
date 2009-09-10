Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbZIJHux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbZIJHux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 03:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZIJHux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 03:50:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42565 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbZIJHuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 03:50:52 -0400
Date: Thu, 10 Sep 2009 17:50:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org
Subject: linux-next: merge window reminder
Message-Id: <20090910175048.073006e5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Sep_2009_17_50_48_+1000_iVGz=Xb9sKZD=Zot"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Sep_2009_17_50_48_+1000_iVGz=Xb9sKZD=Zot
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do not add code destined for 2.6.33 into linux-next trees until
(at least) 2.6.32-rc1 is out.  This will hopefully give those who have
stuff destined for just after -rc1 a chance.

Also this time can be used productively to fix the bugs we left in
2.6.31.  :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Sep_2009_17_50_48_+1000_iVGz=Xb9sKZD=Zot
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqor9gACgkQjjKRsyhoI8zNygCbByF1C3lqapIY2kvJSmKYbMWj
yPcAnAl3KLO6oh0vYmY68vtYpLVk5HLr
=BbY6
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Sep_2009_17_50_48_+1000_iVGz=Xb9sKZD=Zot--
