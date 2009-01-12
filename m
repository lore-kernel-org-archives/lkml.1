Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZALKd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZALKd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZALKds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:33:48 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41775 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZALKds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:33:48 -0500
Date: Mon, 12 Jan 2009 21:33:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] Kernel memory leak detector
Message-Id: <20090112213339.feefdd02.sfr@canb.auug.org.au>
In-Reply-To: <20090112022138.bd2e6ce4.akpm@linux-foundation.org>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	<20090108144538.e5195575.akpm@linux-foundation.org>
	<1231753866.10982.11.camel@pc1117.cambridge.arm.com>
	<20090112022138.bd2e6ce4.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__12_Jan_2009_21_33_39_+1100_qR3/GgbOPpoA.pmt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Jan_2009_21_33_39_+1100_qR3/GgbOPpoA.pmt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Jan 2009 02:21:38 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> The many trees in linux-next are actually based on current mainline.=20
> So if you can prepare and maintain a tree based on current mainline,
> Stephen could integrate that into linux-next, hopefully.

That's what I'm here for :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Jan_2009_21_33_39_+1100_qR3/GgbOPpoA.pmt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklrHIMACgkQjjKRsyhoI8yJtACePHOtKs8O/jcqedXPThN2EEdN
N8YAn3cz5qOEAi8u3/RTs4cuwoUcJvgU
=uVhu
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Jan_2009_21_33_39_+1100_qR3/GgbOPpoA.pmt--
