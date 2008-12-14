Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYLNRGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYLNRGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 12:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYLNRGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 12:06:25 -0500
Received: from server.klug.on.ca ([205.189.48.131]:4854 "EHLO
	server.klug.on.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYLNRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 12:06:25 -0500
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <9695C60B-CC91-41B3-87BB-D687E764BE30@gmail.com>
References: <20081214031659.4b700a2d@liberty.rlwhome.lan>
	 <1229263715.330.29.camel@pc.interlinx.bc.ca>
	 <9695C60B-CC91-41B3-87BB-D687E764BE30@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-r1S9alMcOIE+T+o+54de"
Date: Sun, 14 Dec 2008 12:06:09 -0500
Message-Id: <1229274372.330.34.camel@pc.interlinx.bc.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-r1S9alMcOIE+T+o+54de
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-14 at 07:35 -0800, Justin P. Mattock wrote:
> Is there quite possibly another
> Graphics module you can plug-in,
> Just to see

By module, do you mean software or hardware?  I have to assume you mean
software as this is a laptop.  But I don't know what other module I
could use.  The graphics chip is a:

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960
Integrated Graphics Controller (rev 03)

Maybe I'm just completely mis-understanding you.

BTW, FWIW, this problem happens without an X server even.  Just plain
console driver.

b.


--=-r1S9alMcOIE+T+o+54de
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklFPO8ACgkQl3EQlGLyuXBf2gCg4uHlip5PnarQ9g+nA62DZDMR
UpYAoIUHy48XLlTynU7NUA63k3yxUrxV
=NYNa
-----END PGP SIGNATURE-----

--=-r1S9alMcOIE+T+o+54de--

