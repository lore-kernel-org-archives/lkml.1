Return-Path: <linux-kernel-owner+w=401wt.eu-S1762819AbXJTKrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762819AbXJTKrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 06:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbXJTKrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 06:47:31 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38190 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbXJTKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 06:47:30 -0400
Subject: Re: [PATCH 9/9] RT: Only dirty a cacheline if the priority is
	actually changing
From: Gregory Haskins <ghaskins@novell.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47196C9B.7090909@tiscali.nl>
References: <20071017184745.11272.10024.stgit@novell1.haskins.net>
	 <20071017185113.11272.50568.stgit@novell1.haskins.net>
	 <47196C9B.7090909@tiscali.nl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sNnO6BGh9ADf+J84CRuR"
Date: Sat, 20 Oct 2007 06:44:47 -0400
Message-Id: <1192877087.4088.3.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sNnO6BGh9ADf+J84CRuR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-20 at 04:48 +0200, Roel Kluin wrote:
> Gregory Haskins wrote:
> > We can avoid dirtying a rq related cacheline with a simple check, so wh=
y not.
> >=20
> > Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> > ---
> >=20
> >  0 files changed, 0 insertions(+), 0 deletions(-)
>=20
> I think you wanted a patch here?

Hi Roel,
  I had forgotten to refresh before mailing the patches, but I sent an
immediate followup (which unfortunately was not linked to the original
posting.  For your reference, here is the reposting:

http://article.gmane.org/gmane.linux.rt.user/1626

Sorry for the confusion!

Regards,
-Greg



--=-sNnO6BGh9ADf+J84CRuR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBHGdwfSW61Ku6jJPkRAp4+AJ9iKIrZFzsHhUizYdgrjKnAFUBeDACcCPxN
7kxlmMiqsRQvD/C+w7wgW5Y=
=TkYf
-----END PGP SIGNATURE-----

--=-sNnO6BGh9ADf+J84CRuR--

