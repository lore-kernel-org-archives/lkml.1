Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbZF2Nfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbZF2Nfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZF2Nf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:35:28 -0400
Received: from fe01x03-cgp.akado.ru ([77.232.31.164]:54010 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751073AbZF2Nf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:35:28 -0400
From: Arseniy Lartsev <ars3n@yandex.ru>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: PROBLEM: USB ACM device does not work
Date: Mon, 29 Jun 2009 17:35:15 +0400
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc1-git3-0.1-default; KDE/4.1.3; i686; ; )
Cc: USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <200906282229.35713.ars3n@yandex.ru> <200906291543.52477.ars3n@yandex.ru> <200906291507.45281.oliver@neukum.org>
In-Reply-To: <200906291507.45281.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1449563.q5y9PNbEXu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906291735.23024.ars3n@yandex.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1449563.q5y9PNbEXu
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 29 June 2009 17:07:44 Oliver Neukum wrote:
> Please printk xfertype in the error case of usb_submit_urb()
It equals USB_ENDPOINT_XFER_INT.

--nextPart1449563.q5y9PNbEXu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iJwEAAECAAYFAkpIwxoACgkQIHDkq2F9exaWwgQAtT0IK+pmDxKx8DtC+dt2j8MO
G41nzzRfr7dJD2BcbjMCF0RDiqhwkOZW84sAdc236cqOF7bYN+amPIvnxwpCMVWd
UFKv5D1+iytSyGSXIRxfEkt04pMtz00tfmzJy06XwfSLqzfGdNzBht0pBke4Cp6K
tgOlE/lYVaRlxbFU4Wk=
=saFC
-----END PGP SIGNATURE-----

--nextPart1449563.q5y9PNbEXu--
