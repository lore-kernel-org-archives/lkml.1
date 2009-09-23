Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZIWJUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZIWJUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZIWJUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:20:19 -0400
Received: from gold.linx.net ([195.66.232.40]:35246 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbZIWJUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:20:17 -0400
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
From: Tony Vroon <tony@linx.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4AB9B7B7.30200@kernel.org>
References: <1253560490.2934.42.camel@localhost>
	 <4AB7D349.4000802@zytor.com> <1253566046.2773.10.camel@localhost>
	 <4AB89417.7090005@kernel.org> <1253648186.2766.5.camel@localhost>
	 <4AB9B7B7.30200@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kYHd9J05otW67fPTHDJ0"
Organization: London Internet Exchange (LINX; AS5459)
Date: Wed, 23 Sep 2009 10:19:10 +0100
Message-Id: <1253697550.3434.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kYHd9J05otW67fPTHDJ0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-09-23 at 14:52 +0900, Tejun Heo wrote:
> Can you please do l on the above rip - ffffffff81598250?

I was unable to:
(gdb) l *ffffffff81598250
No symbol "ffffffff81598250" in current context.

Here is my vmlinux, LZMA-packed (~15MB download):
http://www.vroon.org/vmlinux.lzma

Hopefully this will allow you to find out the information requested.

Regards,
Tony V.

--=-kYHd9J05otW67fPTHDJ0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkq56A4ACgkQp5vW4rUFj5oC5wCfdh1vkFIw36PHdUmhjsSCvOUQ
O5UAn0qVDGZ84hK/BAG6m+H0UQ9GYtdu
=bgZR
-----END PGP SIGNATURE-----

--=-kYHd9J05otW67fPTHDJ0--

