Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437Ab0ARDek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0ARDek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 22:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586Ab0ARDej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 22:34:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60642 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab0ARDei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 22:34:38 -0500
Date: Mon, 18 Jan 2010 14:34:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: linux-next: manual merge of the arm tree with the arm-current
 tree
Message-Id: <20100118143429.7ef34dde.sfr@canb.auug.org.au>
In-Reply-To: <20100118013307.GD10014@trinity.fluff.org>
References: <20100118103534.a5dc3c66.sfr@canb.auug.org.au>
	<20100118013307.GD10014@trinity.fluff.org>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jan_2010_14_34_29_+1100_UDMfx2BV6EmZgjJU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jan_2010_14_34_29_+1100_UDMfx2BV6EmZgjJU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Mon, 18 Jan 2010 01:33:07 +0000 Ben Dooks <ben-linux@fluff.org> wrote:
>
> Is that from the merge of next-samsung or from two parts of the ARM
> trees?

I merged the arm-current tree
(ssh://master.kernel.org/home/rmk/linux-2.6-arm.git#master) into
linux-next and then later the arm tree
(ssh://master.kernel.org/home/rmk/linux-2.6-arm.git#devel) and the second
merge produced this conflict.  However, Russell has merged the samsung
tree (git://git.fluff.org/bjdooks/linux.git#next-samsung) into the arm
tree, already.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jan_2010_14_34_29_+1100_UDMfx2BV6EmZgjJU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktT1sUACgkQjjKRsyhoI8xjswCeO9r2XL/ROv3zpdvm2FhwfKzL
f3MAnR4xL7azl0QuKVaZ5ZdrjqSGvFZ9
=XfxJ
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jan_2010_14_34_29_+1100_UDMfx2BV6EmZgjJU--
