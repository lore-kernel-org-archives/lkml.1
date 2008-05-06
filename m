Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbYEFEnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbYEFEnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYEFEnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:43:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51923 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbYEFEnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:43:37 -0400
Date: Tue, 6 May 2008 14:43:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-next@vger.kernel.org,
       sfrench@us.ibm.com, swhiteho@redhat.com, stefanr@s5r6.in-berlin.de,
       jeff@garzik.org, ralf@linux-mips.org, drzeus-list@drzeus.cx,
       jack@ucw.cz, cbou@mail.ru, jens.axboe@oracle.com, ericvh@gmail.com,
       wim@iguana.be, chris@zankel.net, nico@cam.org, clameter@sgi.com,
       ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
Message-Id: <20080506144318.5432cdcc.sfr@canb.auug.org.au>
In-Reply-To: <20080505113128.d68863a2.akpm@linux-foundation.org>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
	<84144f020805051116mdbbea01q39f17bce95c95dbb@mail.gmail.com>
	<20080505113128.d68863a2.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_May_2008_14_43_18_+1000_yS6qlieqTAw2LtLV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_May_2008_14_43_18_+1000_yS6qlieqTAw2LtLV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 5 May 2008 11:31:28 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> So I'd suggest that you have a #for-next which contains material for 2.6.=
26
> and 2.6.27 and a #for-mm which contains material for 2.6.28+.
>=20
> Only problem is, I'd need to generate the #for-next -> #for-mm diff, and
> that particular git operation has been troublesome in the past.

Yeah, it is fine if one is a subset of the other but otherwise fraught
with danger.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_May_2008_14_43_18_+1000_yS6qlieqTAw2LtLV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIH+H1TgG2atn1QN8RAtopAJ9s6CVvLcN56/yMlkPxM5ztOyAk3wCeOiBP
GFjfJAKh4g1jIX36IDKqvpo=
=dWus
-----END PGP SIGNATURE-----

--Signature=_Tue__6_May_2008_14_43_18_+1000_yS6qlieqTAw2LtLV--
