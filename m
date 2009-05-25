Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbZEYGua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbZEYGua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 02:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZEYGuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 02:50:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59676 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZEYGuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 02:50:22 -0400
Date: Mon, 25 May 2009 16:50:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: manual merge of the vfs tree with the  tree
Message-Id: <20090525165013.7d641a6d.sfr@canb.auug.org.au>
In-Reply-To: <20090524220336.GF6471@nowhere>
References: <20090522112326.9eafa340.sfr@canb.auug.org.au>
	<20090524220336.GF6471@nowhere>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_May_2009_16_50_13_+1000_nBQ2_TptCqti_RXw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_May_2009_16_50_13_+1000_nBQ2_TptCqti_RXw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frederic,

On Mon, 25 May 2009 00:03:38 +0200 Frederic Weisbecker <fweisbec@gmail.com>=
 wrote:
>
> So for now, IMO you have the right fix. The end result should be:

Thanks for the confirmation.

> > + 	if (s->s_dirt)
> > + 		reiserfs_write_super(s);
>=20
> But this part seems to solve another conflict, right?
> I'm not sure about it.

See Christoph's reply.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_May_2009_16_50_13_+1000_nBQ2_TptCqti_RXw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoaP6UACgkQjjKRsyhoI8yrpgCeNrLtegTSxyLp8ZkO6tbNBRpu
fPEAnjbGFRyBf7vGlwFEaN8GK+ZeZNT4
=ST76
-----END PGP SIGNATURE-----

--Signature=_Mon__25_May_2009_16_50_13_+1000_nBQ2_TptCqti_RXw--
