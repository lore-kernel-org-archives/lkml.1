Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbYEMAbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbYEMAbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 20:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYEMAbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 20:31:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32954 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbYEMAbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 20:31:10 -0400
Date: Tue, 13 May 2008 10:30:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 12
Message-Id: <20080513103055.d133f60a.sfr@canb.auug.org.au>
In-Reply-To: <20080512082205.8678bbaf.randy.dunlap@oracle.com>
References: <20080512150418.603e29cf.sfr@canb.auug.org.au>
	<20080512082205.8678bbaf.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_May_2008_10_30_55_+1000_k8SrXN6rvsW9oYjr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_May_2008_10_30_55_+1000_k8SrXN6rvsW9oYjr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Mon, 12 May 2008 08:22:05 -0700 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> On Mon, 12 May 2008 15:04:18 +1000 Stephen Rothwell wrote:
>=20
> > News:  I am now providing patches relative to the latest tag in Linus'
> > tree.  I propose to stop providing complete tar balls as they are so
> > large and people will have recent versions of Linus's tree anyway (I
> > assume).  The patches will be named "patch-<upstream tag>-<next tag>".
>=20
> Oh well.  For the record, I don't mind using patches instead of
> complete tarballs, but I would prefer that the patches be relative
> to something like a daily -git snapshot so that using git is not
> required at all.

They will be relative to a tag that Linus adds to his tree and those
tagged trees are always available as tar balls.  i.e. yesterdays patches
were relative to 2.6.26-rc1, today's (and until rc3 comes out) will be
relative to 2.6.26-rc2. Or I could do them against the daily -git
snapshots (or both).  Either way it would cut down on the amount of stuff
I am distributing. Currently there is already about 6G of linux-next
tarballs.

I certainly don't want to make it harder for those who are doing such
good job of testing. Does that make it clearer?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_May_2008_10_30_55_+1000_k8SrXN6rvsW9oYjr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIKOFHTgG2atn1QN8RAhPjAJ4ynCsYX8+9h2YBhT5GN+kP7uaNEACfVEvE
8nVd40l5xRMJCytngL4QrUA=
=WE21
-----END PGP SIGNATURE-----

--Signature=_Tue__13_May_2008_10_30_55_+1000_k8SrXN6rvsW9oYjr--
