Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZIQAfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZIQAfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZIQAfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:35:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37593 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbZIQAfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:35:18 -0400
Date: Thu, 17 Sep 2009 10:35:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] edac: need to export cpu_llc_id
Message-Id: <20090917103513.9a42bdbf.sfr@canb.auug.org.au>
In-Reply-To: <20090916160420.GA12585@aftab>
References: <20090916093935.6bc2c91f.sfr@canb.auug.org.au>
	<20090916044151.GB5767@aftab>
	<20090917014901.1011949d.sfr@canb.auug.org.au>
	<20090916160420.GA12585@aftab>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Sep_2009_10_35_13_+1000_QVSrMQEPrlDXi4X8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Sep_2009_10_35_13_+1000_QVSrMQEPrlDXi4X8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boris,

On Wed, 16 Sep 2009 18:04:20 +0200 Borislav Petkov <borislav.petkov@amd.com=
> wrote:
>
> By the way, fix is already underway to Linus so you might just wait
> a while before applying it to your linux-next mix and pull it from
> upstream instead.

Since Linus hasn't merged your tree yet, I have cherry-picked that one
commit from your tree into my "fixes" tree for today.  I will drop it
when Linus takes your tree.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Sep_2009_10_35_13_+1000_QVSrMQEPrlDXi4X8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqxhEEACgkQjjKRsyhoI8wjYwCfSUVNG0SXFK7UL/aoRWrVdR7x
zCIAnjy8FU8KoyNbfnhbBMWEXewX7kt5
=yW0+
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Sep_2009_10_35_13_+1000_QVSrMQEPrlDXi4X8--
