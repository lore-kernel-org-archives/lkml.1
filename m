Return-Path: <linux-kernel-owner+w=401wt.eu-S968221AbXFHI6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968221AbXFHI6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966731AbXFHI6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:58:25 -0400
Received: from lug-owl.de ([195.71.106.12]:60111 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966722AbXFHI6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:58:23 -0400
Date: Fri, 8 Jun 2007 10:58:21 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jcm@jonmasters.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Jesper Juhl <jesper.juhl@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070608085821.GY2649@lug-owl.de>
Mail-Followup-To: Adrian Bunk <bunk@stusta.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, jcm@jonmasters.org,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Jesper Juhl <jesper.juhl@gmail.com>,
	Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com> <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr> <20070607193413.GR5500@stusta.de> <20070607232248.332edee8@the-village.bc.nu> <20070607232152.GU5500@stusta.de> <20070608004117.57868755@the-village.bc.nu> <20070608000455.GW5500@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NV1faPSjApYYKCht"
Content-Disposition: inline
In-Reply-To: <20070608000455.GW5500@stusta.de>
X-Operating-System: Linux mail 2.6.18-4-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--NV1faPSjApYYKCht
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-08 02:04:55 +0200, Adrian Bunk <bunk@stusta.de> wrote:
> On Fri, Jun 08, 2007 at 12:41:17AM +0100, Alan Cox wrote:
> > (And incidentially since the Linux fs has been defined to be utf-8 for
> > naming for many years you'll find the same problem using "ls")
>=20
> No, "ls" can handle it perfectly:
>=20
> # echo $LANG
> C
> # ls
> ??rsted
> #=20

`ls' may be playing tricks by checking whether its output goes to a
TTY.  Does the terminal also hang for

$ ls | cat
or
$ ls -N

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:                http://catb.org/~esr/faqs/smart-questions.html
the second  :

--NV1faPSjApYYKCht
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGaRotHb1edYOZ4bsRAuHxAJ9lua1rnCIbr3kJY48cSadcmUr9+gCdERHu
sarYXwJkTgJ8RTwXq18k6a0=
=ObPM
-----END PGP SIGNATURE-----

--NV1faPSjApYYKCht--
