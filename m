Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbZGPCd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbZGPCd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 22:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbZGPCd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 22:33:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45410 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbZGPCd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 22:33:58 -0400
Date: Thu, 16 Jul 2009 12:33:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: ttydev series import warning
Message-Id: <20090716123351.6c2ea7a0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Jul_2009_12_33_51_+1000_X/9_J/R+QRHe4tGF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Jul_2009_12_33_51_+1000_X/9_J/R+QRHe4tGF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

Today's linux-next import of the ttydev series produced this error:

tty-fix-sti-race
error: No changes

I just commented out that empty patch.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Jul_2009_12_33_51_+1000_X/9_J/R+QRHe4tGF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpekY8ACgkQjjKRsyhoI8yQsgCgsy3t8L9TikHQg97WBL4RuTlG
gPUAoISXGVt0rXGlYaL7Z4XnMn55oW24
=9EvT
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Jul_2009_12_33_51_+1000_X/9_J/R+QRHe4tGF--
