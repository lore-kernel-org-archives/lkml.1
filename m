Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYJXSu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYJXSu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbYJXSuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:50:15 -0400
Received: from mail.anarazel.de ([217.115.131.40]:38381 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbYJXSuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:50:14 -0400
From: Andres Freund <andres@anarazel.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Current suspend issues on Lenovo X200 (w/ Intel graphics)
Date: Fri, 24 Oct 2008 20:50:09 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-andres-05577-g0cfd810; KDE/4.1.2; x86_64; ; )
Cc: "Nico -telmich- Schottelius" <nico-linux-next@schottelius.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham@crca.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20081023204326.GB4175@denkbrett.schottelius.org> <200810241630.52740.andres@anarazel.de> <20081024180248.GH22217@kernel.dk>
In-Reply-To: <20081024180248.GH22217@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart64478070.CzIUGIDG5Z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810242050.10972.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart64478070.CzIUGIDG5Z
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Friday 24 October 2008 20:02:48 Jens Axboe wrote:
> > The kernel has a fix for memory management for GM45 cards since
> > 2.6.28-rc1 which require a newer driver, so trying this may be benifical
> > (patch in reply to your first post).
> No go, same for me on x60 on ubuntu 8.10-rc1.
Uh, sorry, just now recognized you wrote x60 and not x200 (I guess the x60 =
has=20
no GM45?).

Andres

--nextPart64478070.CzIUGIDG5Z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkCGOIACgkQporPraT14ih6VgCfagYNTb9pS5Wsgh1+NoduCjDE
FbsAnAkodT+n8RxE6CpNw9XbeQJ2Gsjx
=+GiO
-----END PGP SIGNATURE-----

--nextPart64478070.CzIUGIDG5Z--
