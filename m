Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYK1Bhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYK1Bhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 20:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYK1Bho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 20:37:44 -0500
Received: from home.keithp.com ([63.227.221.253]:57295 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYK1Bho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 20:37:44 -0500
Subject: Re: [PATCH] usb/serial/cp2101: Add support for cp2103 GPIO pins
From: Keith Packard <keithp@keithp.com>
To: Greg KH <gregkh@suse.de>
Cc: keithp@keithp.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081127184109.GA20479@suse.de>
References: <1227774576-5503-1-git-send-email-keithp@keithp.com>
	 <1227774576-5503-2-git-send-email-keithp@keithp.com>
	 <20081127105823.30786bf4@lxorguk.ukuu.org.uk>
	 <1227810026.4277.48.camel@aiko.keithp.com> <20081127184109.GA20479@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FLeCJaoc0YxJFA6fKQMv"
Date: Thu, 27 Nov 2008 17:31:43 -0800
Message-Id: <1227835903.4277.69.camel@aiko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FLeCJaoc0YxJFA6fKQMv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-27 at 10:41 -0800, Greg KH wrote:

> Can you do the same thing here as well?  Or do you also need to
> send/recieve serial data through the device at the same time?

I was hoping to use both at the same time; the target device has a
serial port that I'll need to get working eventually.

Besides, libusb scares me, but if that's the officially supported
mechanism, I can manage; I don't need it to go fast for this
application.

--=20
keith.packard@intel.com

--=-FLeCJaoc0YxJFA6fKQMv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJL0n/Qp8BWwlsTdMRAg4gAJ4xe0hcBCitTge7taTtgYwqZyv4RgCfbAOV
9qbI3pZ9a8CAZ5DKKKakjyY=
=LSIF
-----END PGP SIGNATURE-----

--=-FLeCJaoc0YxJFA6fKQMv--

