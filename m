Return-Path: <linux-kernel-owner+w=401wt.eu-S937826AbXFHFYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937826AbXFHFYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 01:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbXFHFYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 01:24:39 -0400
Received: from mx33.mail.ru ([194.67.23.194]:22028 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001AbXFHFYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 01:24:38 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Fri, 8 Jun 2007 09:24:28 +0400
User-Agent: KMail/1.9.7
Cc: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       "Samuel Ortiz" <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706070045.14040.arvidjaar@mail.ru> <200706071234.47517.bjorn.helgaas@hp.com>
In-Reply-To: <200706071234.47517.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1921784.EeX6QzhfRO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706080924.29757.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1921784.EeX6QzhfRO
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 07 June 2007, Bjorn Helgaas wrote:
> In 2.6.21, smsc-ircc2 at least found the device.  So we definitely have
> a problem because in 2.6.22-rc, we don't find the device.
>
> What laptop do you have?  Maybe I can find one to play with.
>

This is Toshiba Portege 4000. The rest of your questions later when I have=
=20
time :)

--nextPart1921784.EeX6QzhfRO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGaOgNR6LMutpd94wRAoWZAJ0ZgY6mH/jW1/MEoE2GGnrWODJXVgCeN+40
Mcmt/unbIx+Q4M6pgcsj9Do=
=VHrr
-----END PGP SIGNATURE-----

--nextPart1921784.EeX6QzhfRO--
