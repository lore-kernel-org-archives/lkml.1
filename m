Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYHAXCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYHAXCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYHAXCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:02:06 -0400
Received: from home.keithp.com ([63.227.221.253]:1570 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYHAXCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:02:05 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080801205052.GA28747@infradead.org>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <1217573919-7496-2-git-send-email-eric@anholt.net>
	 <20080801205052.GA28747@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iZ9NSfjRGPqhQCz+6pqz"
Date: Fri, 01 Aug 2008 16:01:58 -0700
Message-Id: <1217631718.23437.290.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iZ9NSfjRGPqhQCz+6pqz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-01 at 16:50 -0400, Christoph Hellwig wrote:

> Nope.  Let the userspace protion create a file in shmfs instead of
> adding fugly kernel interfaces hdiing this fact.

I can't create that many files; I need thousands of them.

--=20
keith.packard@intel.com

--=-iZ9NSfjRGPqhQCz+6pqz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIk5XmQp8BWwlsTdMRAkvkAKCCANojD645QZac8rb635OOLWj7ygCglUMW
PSfvgmssW3yS+iLwCZRdtJc=
=yw47
-----END PGP SIGNATURE-----

--=-iZ9NSfjRGPqhQCz+6pqz--

