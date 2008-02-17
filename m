Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYBQF0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYBQF0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 00:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbYBQF0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 00:26:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58355 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbYBQF0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 00:26:09 -0500
Date: Sun, 17 Feb 2008 16:25:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080217162559.d0b01760.sfr@canb.auug.org.au>
In-Reply-To: <1203174872.3182.16.camel@localhost.localdomain>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<adalk5np1h5.fsf@cisco.com>
	<20080215120222.b3263e4a.sfr@canb.auug.org.au>
	<1203174872.3182.16.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__17_Feb_2008_16_25_59_+1100_K/qxl4h1TsGgb24k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__17_Feb_2008_16_25_59_+1100_K/qxl4h1TsGgb24k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Sat, 16 Feb 2008 09:14:32 -0600 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> Do you have the tree and build logs available anywhere?  I'd like to
> turn off the merge tree builds when this is able to replace it.

The tree is at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git - or did
you mean the logs of creating the tree.  I currently ceate the tree
fairly manually (as I slowly script what can be) and so have no logs of
that process.

The build logs that I have some control over are at
http://kisskb.ellerman.id.au/kisskb/branch/9/.  I am hoping to expand on
the arch/config combinations over time (I have to convince my tame cross
compiler builder :-)).  I also hope that others will build this tree for
themselves and publish the results.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__17_Feb_2008_16_25_59_+1100_K/qxl4h1TsGgb24k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHt8VsTgG2atn1QN8RArc9AJ0WKVtTy9fmH9+XQR+uH8vfA089SACdG8ka
YBjj0CFtx6pp6SFatrupVLY=
=qVT9
-----END PGP SIGNATURE-----

--Signature=_Sun__17_Feb_2008_16_25_59_+1100_K/qxl4h1TsGgb24k--
