Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbYFCVlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbYFCVlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYFCVlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:41:00 -0400
Received: from anubis.ausil.us ([216.75.14.43]:51676 "EHLO mail.ausil.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbYFCVlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:41:00 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2008 17:41:00 EDT
To: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 broke X on SPARC Ultra5
From: Dennis Gilmore <dennis@ausil.us>
Date: Tue, 3 Jun 2008 16:30:30 -0500
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2987902.khisIloDI5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200806031630.36487.dennis@ausil.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2987902.khisIloDI5
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 03 June 2008, you wrote:
> From: Mikael Pettersson <mikpe@it.uu.se>
> Date: Tue, 3 Jun 2008 21:26:35 +0200
>
> > It's a shame though that a bug fix needs to have such draconian
> > consequences.
>
> I agree, but the way the X server (tried to) work on sparc before
> libpciaccess was even more draconian.
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

well i can confirm that X server 1.5 works fine on 2.6.25.4  not that its=20
unexpected.

Dennis

--nextPart2987902.khisIloDI5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhFt/wACgkQkSxm47BaWfdSbgCePhNny1O9esiPnT6bko36zoRp
KcEAnAg1FNs4OaocNCn5xwON1azuDdct
=SngN
-----END PGP SIGNATURE-----

--nextPart2987902.khisIloDI5--
