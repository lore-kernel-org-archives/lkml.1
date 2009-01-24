Return-Path: <linux-kernel-owner+w=401wt.eu-S1751293AbZAXFP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbZAXFP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 00:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbZAXFPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 00:15:20 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:38068 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750724AbZAXFPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 00:15:19 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Clarification of allowed context for crypto routines
Date: Sat, 24 Jan 2009 08:15:02 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090123223150.GA1264@gondor.apana.org.au>
In-Reply-To: <20090123223150.GA1264@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1971456.Rklm8hRX3Q";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901240815.08903.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1971456.Rklm8hRX3Q
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 24 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 01:31:50 Herbert Xu wrote:
>
> 2) The highmem primitives we use are currently softirq only.  We
> could make them work for hardirq as well, but because of 1) we
> didn't.
>

Could you point to example of such primitive in code under crypto?

Thank you!

--nextPart1971456.Rklm8hRX3Q
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl6o9cACgkQR6LMutpd94zN8gCfZTFWXNkXz5VpKiRpnUOZvACe
6wEAn1DmGc5hzBo1pjjp8caVyTmXhCTE
=ZbNI
-----END PGP SIGNATURE-----

--nextPart1971456.Rklm8hRX3Q--
