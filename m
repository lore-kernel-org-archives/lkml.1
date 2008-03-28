Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYC1Eve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYC1Eve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 00:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYC1EvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 00:51:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50480 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbYC1EvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 00:51:23 -0400
Date: Fri, 28 Mar 2008 15:51:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: down_spin() implementation
Message-Id: <20080328155107.e9d8866c.sfr@canb.auug.org.au>
In-Reply-To: <20080327141508.GL16721@parisc-linux.org>
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com>
	<20080326123239.GG16721@parisc-linux.org>
	<1FE6DD409037234FAB833C420AA843ECE9EB1C@orsmsx424.amr.corp.intel.com>
	<20080327141508.GL16721@parisc-linux.org>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_Mar_2008_15_51_07_+1100_dVUL9o9+k43d_Bn2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Mar_2008_15_51_07_+1100_dVUL9o9+k43d_Bn2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Willy,

On Thu, 27 Mar 2008 08:15:08 -0600 Matthew Wilcox <matthew@wil.cx> wrote:
>
> Stephen, I've updated the 'semaphore' tag to point ot the same place as
> semaphore-20080327, so please change your linux-next tree from pulling
> semaphore-20080314 to just pulling plain 'semaphore'.  I'll use this
> method of tagging from now on.

Thanks. I read this to late for today's tree, but I will fix it up for
the next one.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_Mar_2008_15_51_07_+1100_dVUL9o9+k43d_Bn2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH7Hk+TgG2atn1QN8RAl+9AJwO3qpUPqXmQXwE1clMcEZF9ZV8RgCfRSx6
uWXD5SK8cMNVZ8YwG2QNKr0=
=RLpt
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Mar_2008_15_51_07_+1100_dVUL9o9+k43d_Bn2--
