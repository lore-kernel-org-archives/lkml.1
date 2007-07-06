Return-Path: <linux-kernel-owner+w=401wt.eu-S1762730AbXGFHRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730AbXGFHRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760131AbXGFHRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:17:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55842 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760682AbXGFHRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:17:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Nix <nix@esperi.org.uk>
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Date: Fri, 6 Jul 2007 03:19:35 -0400
User-Agent: KMail/1.9.7
Cc: List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <8CYT9-4Ou-23@gated-at.bofh.it> <20070705205523.GA15202@suse.de> <87zm2aav9h.fsf@hades.wkstn.nix>
In-Reply-To: <87zm2aav9h.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3306583.LmEv7xX1xf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707060319.36460.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3306583.LmEv7xX1xf
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 06 July 2007, Nix wrote:
> On 5 Jul 2007, Bernhard Walle stated:
> >                                While cmake itself isn't the problem,
> > often, it also depends on the version of cmake that is installed. The
> > good idea about auto* tools is the idea that you don't need to install
> > any tools to build, just to develop. A POSIX shell and Perl should be
> > installed everywhere ...
>
> You don't need Perl to run configure scripts, either, and it's only
> recently that it started requiring a POSIX shell rather than something
> of the calibre of Solaris's /bin/sh.

since when does autotools require a POSIX shell ?
-mike

--nextPart3306583.LmEv7xX1xf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARo3tCEFjO5/oN/WBAQLXQg//T6FAdP//euhfNssk3WsJJ8n6x2JfDF4X
SXqIDzTbEpHKLOyJYsyizA7TUf+FXIbQVc++7bnk9d+B0KG7c+8/LjLACeSI1jvI
UR/K5CkgT2xxpHZ76JAU7RCPhDfU+C+sp7NHp/BYJxE6v6/t18+zVtCa1GJV5odz
desCwOnQMSQr7AfR2/SvKCUuT75Hkz6C8woaHP/W8FlMvM0og73N/7VZLT6ccPm7
LjI97S8VhwwWUcLDN4quQv/PezIQlwPzRoWTOcstJby2TiaRaknV3hT9lLHCg1kA
TMzxK4lFALAWxfT5UGSnj8DsYfSKYbJPMlG2VNdMVO+VokgvqF30wRsuoqSiWf46
/8VFJR0S0ADhhNdUYb8ZJTvkVZ4EH9e0O6ieWRasMQuaFY739Mq7QHaldDFQXvb6
6XQHTRPRdVS3Urmpswg0HnBWl1o/3cH4KL+IsVcxC1d3y66p4WUqCk9RH8N3gFp7
wXqWyRvC0MHP2pselGBwpseYZXgzv9k33VTisjlslgPjXSkqwk+DA21WIrqY6MDS
+2mbSo4WF/8ygibBliM1wc/ISiq9ZvcqqsA1Ou/M/JFL3o5eH9HgjEpElYCy8uHC
QN2RdOJ0fwKt2XlrBols9dXfQ4tAchTGBNccgbAYbuhiq03fTSHnCIKepsE1Uwdl
QHaa0hdaYjE=
=pc9u
-----END PGP SIGNATURE-----

--nextPart3306583.LmEv7xX1xf--
