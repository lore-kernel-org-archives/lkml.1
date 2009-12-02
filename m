Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZLBGFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZLBGFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZLBGFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:05:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56355 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbZLBGFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:05:09 -0500
Date: Wed, 2 Dec 2009 17:05:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: michal.simek@petalogix.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: problems in linux-next (Was: Re: linux-next: Tree for December
 1)
Message-Id: <20091202170505.6fc883d7.sfr@canb.auug.org.au>
In-Reply-To: <4B15FDCD.7040401@kernel.org>
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
	<4B14D6E2.2040704@petalogix.com>
	<20091201210343.f0a1d353.sfr@canb.auug.org.au>
	<4B15FDCD.7040401@kernel.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Dec_2009_17_05_05_+1100_rJWUxyWYaPmWGONN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Dec_2009_17_05_05_+1100_rJWUxyWYaPmWGONN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Wed, 02 Dec 2009 14:40:29 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> The wq changes need to be rebased due to scheduler related bits.  I'm
> backing them out for now.  I'll fix this problem before pushing the
> series out again.

OK, thanks for letting me know.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Dec_2009_17_05_05_+1100_rJWUxyWYaPmWGONN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksWA5EACgkQjjKRsyhoI8xyEQCgum8IQFc4laelvd/xVbl6Rf2T
gysAnjF5d1dECjAM5OM75XDNhOBMUpvz
=VY0g
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Dec_2009_17_05_05_+1100_rJWUxyWYaPmWGONN--
