Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbYL2Dpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbYL2Dpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 22:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYL2Dpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 22:45:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45556 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbYL2Dpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 22:45:42 -0500
Date: Mon, 29 Dec 2008 14:45:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: dhowells@redhat.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bernd Schubert <bernd.schubert@fastmail.fm>, nfsv4@linux-nfs.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, steved@redhat.com,
       linux-fsdevel@vger.kernel.org, rwheeler@redhat.com,
       linux-next@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-Id: <20081229144533.4a0ab696.sfr@canb.auug.org.au>
In-Reply-To: <20081219110539.7e7e230c.sfr@canb.auug.org.au>
References: <8930.1229560221@redhat.com>
	<20081218142420.GA16728@infradead.org>
	<20081218123601.11810b7f.akpm@linux-foundation.org>
	<200812190007.34581.bernd.schubert@fastmail.fm>
	<20081218152616.a24c013f.akpm@linux-foundation.org>
	<20081219110539.7e7e230c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Dec_2008_14_45_33_+1100_iuBFkyjGgVegFVSl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Dec_2008_14_45_33_+1100_iuBFkyjGgVegFVSl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Fri, 19 Dec 2008 11:05:39 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Given the ongoing discussions around FS-Cache, I have removed it from
> linux-next.  Please ask me to include it again (if sensible) once some
> decision has been reached about its future.

What was the result of discussions around FS-Cache?  I ask because it
reappeared in linux-next today via the nfs tree (merged into that on Dec
24 and 25) ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Dec_2008_14_45_33_+1100_iuBFkyjGgVegFVSl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklYR90ACgkQjjKRsyhoI8w2TwCfbPLtgwfzf5IZvp68VjbeV80G
YHQAn3oqSuhjkCpzR0xdnKHm86LACwdN
=m9lC
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Dec_2008_14_45_33_+1100_iuBFkyjGgVegFVSl--
