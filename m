Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZJ3ISh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZJ3ISh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 04:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZJ3ISg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 04:18:36 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54913 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbZJ3ISf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 04:18:35 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: update Kconfig text to mark as deprecated
Date: Fri, 30 Oct 2009 09:18:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-tp42-toi-3.0.1-04850-g4eddd0d; KDE/4.3.2; i686; ; )
Cc: David Miller <davem@davemloft.net>, hancockrwd@gmail.com,
       linux-ide@vger.kernel.org
References: <4AE64FCC.4030102@gmail.com> <20091029.173028.248393897.davem@davemloft.net> <200910300915.51836.Martin@lichtvoll.de> (sfid-20091030_091707_632352_07360635)
In-Reply-To: <200910300915.51836.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2747328.58xuxTDsLv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200910300918.39261.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2747328.58xuxTDsLv
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Am Freitag 30 Oktober 2009 schrieb Martin Steigerwald:
> Am Freitag 30 Oktober 2009 schrieb David Miller:
> > And yes I absolutely do consider it too onerous to change my fstab
> > because I have to (or want to be able to) go back to older kernels
> > which will only have the IDE stack enabled.  I refuse to have to
> > monkey around with my fstab every time I want to go back and forth.
>=20
> You don't need to when you used UUID or LABEL - I prefer the later
>  cause  its more readable. Actually I never quite understood while one
>  would want to use dynamic things like /dev/hdd or /dev/sdb in the
>  first place. Thats for me not that much better than C: or D:. Connect
>  your harddisks differently and you are screwed.

One thing to add: If you use a InitRD, you can use UUID or LABEL in GRUB 1=
=20
as well. I believe GRUB 2 at leasts supports UUID out of the box, but=20
better check this, before relying on my word.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2747328.58xuxTDsLv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkrqoV8ACgkQmRvqrKWZhMftzACcCPbwpx6uhUY1rA0kjQPygVS/
NdgAoLMOzbX6tmZ2EPbZiD0yA8mXOu+f
=Dvuo
-----END PGP SIGNATURE-----

--nextPart2747328.58xuxTDsLv--
