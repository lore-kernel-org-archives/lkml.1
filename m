Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZIBCAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZIBCAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 22:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbZIBCAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 22:00:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58246 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533AbZIBCAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 22:00:40 -0400
Date: Wed, 2 Sep 2009 12:00:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, David Chinner <david@fromorbit.com>,
       xfs-masters@oss.sgi.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>
Subject: Re: linux-next: xfs tree build failure
Message-Id: <20090902120035.2f23b903.sfr@canb.auug.org.au>
In-Reply-To: <F0C21C0B-E90E-44DF-B094-CC5F1DA7EDCE@sgi.com>
References: <20090902112509.739ce995.sfr@canb.auug.org.au>
	<20090902012844.GA15549@lst.de>
	<F0C21C0B-E90E-44DF-B094-CC5F1DA7EDCE@sgi.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Sep_2009_12_00_35_+1000_TXo/kl=Ign7qp17O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Sep_2009_12_00_35_+1000_TXo/kl=Ign7qp17O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felix, Christoph,

On Tue, 1 Sep 2009 20:54:07 -0500 Felix Blyakher <felixb@sgi.com> wrote:
>
> The fix is now in official xfs tree as well.

Thanks, I will pick it up tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Sep_2009_12_00_35_+1000_TXo/kl=Ign7qp17O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqd0cMACgkQjjKRsyhoI8wcFACdH2XmzoFvZodtx12fs91iNNZ/
UToAn1ZrLIUg9z3SkO6NmLGVT5ABfoGB
=Ovd8
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Sep_2009_12_00_35_+1000_TXo/kl=Ign7qp17O--
