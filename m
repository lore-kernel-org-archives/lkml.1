Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZFVKwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZFVKwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 06:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZFVKwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 06:52:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46266 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbZFVKwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 06:52:31 -0400
Date: Mon, 22 Jun 2009 20:52:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org, jdike@addtoit.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
Message-Id: <20090622205226.fee30ba8.sfr@canb.auug.org.au>
In-Reply-To: <20090622085735.GB6499@cr0.nay.redhat.com>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com>
	<4A3F4448.30502@panasas.com>
	<20090622085735.GB6499@cr0.nay.redhat.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Jun_2009_20_52_26_+1000_OnL4O7BVnN3vMgjy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Jun_2009_20_52_26_+1000_OnL4O7BVnN3vMgjy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Amerigo,

On Mon, 22 Jun 2009 16:57:35 +0800 Amerigo Wang <xiyou.wangcong@gmail.com> =
wrote:
>
> Stephan, could you please also do compiling tests for UML in your -next t=
ree?
>=20
> Thanks!

I would be happy to do this, all I need is for someone to tell me how to
do this given we have PowerPC hosts so our X86 compilers are cross
compilers.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Jun_2009_20_52_26_+1000_OnL4O7BVnN3vMgjy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko/YmoACgkQjjKRsyhoI8wukQCfSRF8ekFDP38V7yoq6KQH0Fa6
ZwcAnj0RIJEp+suHIC/H7iPa0v/gLuh/
=AS4I
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Jun_2009_20_52_26_+1000_OnL4O7BVnN3vMgjy--
