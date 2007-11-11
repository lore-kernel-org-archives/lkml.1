Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbXKKTX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbXKKTX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 14:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbXKKTXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 14:23:18 -0500
Received: from mx7.mail.ru ([194.67.23.27]:17255 "EHLO mx7.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbXKKTXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 14:23:17 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.24-rc1: pata_acpi fails to activate DMA for DVD-ROM on ALi M5229 secondary channel
Date: Sun, 11 Nov 2007 22:23:12 +0300
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200710262130.03567.arvidjaar@mail.ru> <20071026202559.01161aa9@the-village.bc.nu>
In-Reply-To: <20071026202559.01161aa9@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1391882.HEx2pAVv0S";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711112223.13542.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1391882.HEx2pAVv0S
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 26 October 2007, Alan Cox wrote:
> On Fri, 26 Oct 2007 21:30:02 +0400
> Andrey Borzenkov <arvidjaar@mail.ru> wrote:
>=20
> > Running legacy IDE drivers apparently works in DMA mode for both:
>=20
> Thanks - can you send me an lspci -vvxxx off list
>=20

BTW in rc2 it does not even boot - it babbles something about
Unable to determine IRQ for 00:04.0  (which is IDE controller) and that is
the end of story. No IDE device is found.

--nextPart1391882.HEx2pAVv0S
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHN1ahR6LMutpd94wRArQGAJ4/VSZirE4Rw2sjM79cfRzukWo5FACgq8WY
wCkAmoXOtHEWrESTIsXvkNk=
=RyK8
-----END PGP SIGNATURE-----

--nextPart1391882.HEx2pAVv0S--
