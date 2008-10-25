Return-Path: <linux-kernel-owner+w=401wt.eu-S1751256AbYJYCJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbYJYCJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 22:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYJYCI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 22:08:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44297 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbYJYCI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 22:08:57 -0400
Date: Sat, 25 Oct 2008 13:08:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       jmorris@us.ibm.com
Subject: Re: [PATCH] User namespaces: set of cleanups (v2)
Message-Id: <20081025130851.379cfac0.sfr@canb.auug.org.au>
In-Reply-To: <11290.1224873841@redhat.com>
References: <20081024174838.GA24466@us.ibm.com>
	<11290.1224873841@redhat.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__25_Oct_2008_13_08_51_+1100_7jjf3vG=YXE+2exR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__25_Oct_2008_13_08_51_+1100_7jjf3vG=YXE+2exR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Fri, 24 Oct 2008 19:44:01 +0100 David Howells <dhowells@redhat.com> wrot=
e:
>
> Serge E. Hallyn <serue@us.ibm.com> wrote:
>=20
> > I've just tested with David's plain creds-v3 tree
>=20
> Note the creds-v4 branch is now current.  Is it worth me replacing that w=
ith a
> tree that just has a master branch to simplify things?

It would be good if you could have a "next" (or "creds-next" or
something) branch in your tree and I can fetch that (that way I don't
have to keep updating my configs).  It is OK if thet branch rebases and
may just be an alias for another branch (or a subset if you have
experimental stuff in there.  Remember "posted, reviewed, tested before
it is in linux-next".

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__25_Oct_2008_13_08_51_+1100_7jjf3vG=YXE+2exR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkCf7MACgkQjjKRsyhoI8zIrACgoYPSu0buce5XGuKpM1o7xgww
7+8An0oji/ivHVXocA9gz4CDVYcZVzLU
=kTNv
-----END PGP SIGNATURE-----

--Signature=_Sat__25_Oct_2008_13_08_51_+1100_7jjf3vG=YXE+2exR--
