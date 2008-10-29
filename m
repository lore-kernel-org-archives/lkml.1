Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYJ2HgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYJ2HgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 03:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYJ2HgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 03:36:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46451 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbYJ2HgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 03:36:14 -0400
Date: Wed, 29 Oct 2008 18:36:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: David Howells <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>, jmorris@us.ibm.com
Subject: Re: [PATCH] User namespaces: set of cleanups (v2)
Message-Id: <20081029183600.a17df43b.sfr@canb.auug.org.au>
In-Reply-To: <20081028162159.GA15342@us.ibm.com>
References: <20081024174838.GA24466@us.ibm.com>
	<20081025130531.ca063206.sfr@canb.auug.org.au>
	<20081028162159.GA15342@us.ibm.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Oct_2008_18_36_00_+1100_htOLP4/jf7YcXgvT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Oct_2008_18_36_00_+1100_htOLP4/jf7YcXgvT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Serge,

On Tue, 28 Oct 2008 11:21:59 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wro=
te:
>
> The tree is up at:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/userns-2.6#next

I have added this today.

> with just two patches on top of David's creds-v4.

This will be OK as long as David does not rebase his tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Oct_2008_18_36_00_+1100_htOLP4/jf7YcXgvT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkIEmAACgkQjjKRsyhoI8xqKACcDGSEdk/3wafso4xutidhfqjF
VqoAnRVtvQIUGyPiyAA3v+EXPCQc1RHB
=oBND
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Oct_2008_18_36_00_+1100_htOLP4/jf7YcXgvT--
