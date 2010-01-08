Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627Ab0AHBTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0AHBTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 20:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611Ab0AHBTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 20:19:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40613 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab0AHBTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 20:19:10 -0500
Date: Fri, 8 Jan 2010 12:19:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>, Sage Weil <sage@newdream.net>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: linux-next: nfs/ceph tree build failure
Message-Id: <20100108121903.6a096bc1.sfr@canb.auug.org.au>
In-Reply-To: <1262909913.2659.47.camel@localhost>
References: <20100108111136.3feae8c6.sfr@canb.auug.org.au>
	<1262909913.2659.47.camel@localhost>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Jan_2010_12_19_03_+1100_5UAFgA1/S_7U34Zn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Jan_2010_12_19_03_+1100_5UAFgA1/S_7U34Zn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

On Thu, 07 Jan 2010 19:18:33 -0500 Trond Myklebust <trond.myklebust@fys.uio=
.no> wrote:
>
> The patch itself looks correct to me.

Thanks for the confirmation.

> How would you like me to proceed? Should I revert the VM changes from
> the NFS linux-next tree, or would you be OK with keeping the above patch
> for now?

I am OK with keeping the patch - we just need to remember it during the
next merge window.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Jan_2010_12_19_03_+1100_5UAFgA1/S_7U34Zn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktGiAcACgkQjjKRsyhoI8yNAgCgqm5Ad/AF8O3eU8ndU8ZJc98I
TTwAn1fIMvabHKzzxgX8dqYpQWTOEed0
=80A/
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Jan_2010_12_19_03_+1100_5UAFgA1/S_7U34Zn--
