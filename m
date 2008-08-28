Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYH1H6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYH1H6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYH1H6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:58:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46802 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbYH1H6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:58:43 -0400
Date: Thu, 28 Aug 2008 17:58:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: sparc build failure
Message-Id: <20080828175836.400efd25.sfr@canb.auug.org.au>
In-Reply-To: <20080827.200350.79735512.davem@davemloft.net>
References: <20080828114602.6c6df4a2.sfr@canb.auug.org.au>
	<20080827.190409.80969099.davem@davemloft.net>
	<20080827.200350.79735512.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Aug_2008_17_58_36_+1000_nREVDnmBN8i.YwO2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Aug_2008_17_58_36_+1000_nREVDnmBN8i.YwO2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 27 Aug 2008 20:03:50 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> Here's what I'll likely push to linus to fix this.
>=20
> Thanks for the report Stephen.
>=20
> sparc32: Implement smp_call_function_single().

I have applied this to linux-next today as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Aug_2008_17_58_36_+1000_nREVDnmBN8i.YwO2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAki2WqwACgkQjjKRsyhoI8x4SwCeNG6b91aR7EzRpf+guUJ6Bmr0
/H8An0ldlCAnNhSKRsrJIVkjWi88Q8q7
=XcsN
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Aug_2008_17_58_36_+1000_nREVDnmBN8i.YwO2--
