Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZINIzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZINIzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 04:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbZINIzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 04:55:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44933 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbZINIzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 04:55:08 -0400
Date: Mon, 14 Sep 2009 18:55:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mikael Pettersson <mikpe@it.uu.se>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: linux-next: manual merge of the security-testing tree with the
 arm tree
Message-Id: <20090914185500.fc9cf713.sfr@canb.auug.org.au>
In-Reply-To: <20090914081220.GA14204@flint.arm.linux.org.uk>
References: <20090903154700.2d4538cf.sfr@canb.auug.org.au>
	<20090914130355.ff26d669.sfr@canb.auug.org.au>
	<20090914081220.GA14204@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Sep_2009_18_55_00_+1000_9WBe_oBUfVkAk1d4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Sep_2009_18_55_00_+1000_9WBe_oBUfVkAk1d4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Sep 2009 09:12:21 +0100 Russell King <rmk+lkml@arm.linux.org.uk>=
 wrote:
>
> On Mon, Sep 14, 2009 at 01:03:55PM +1000, Stephen Rothwell wrote:
> > This is now a conflict between the arm tree and Linus' tree (as the
> > security-testing tree has been merged).
>=20
> That's going to be a problem then - I've sent Linus a pull request last
> Saturday, and so my tree is now frozen pending a response from Linus.

You could, of course, send an email to Linus saying something like
"linux-next has shown that you will get a conflict in
arch/arm/kernel/signal.c when you merge the arm tree.  You could fix it
like this: ... or I could merge your tree and fix it locally and let you
know when it is done."

Actually Linus is probably clever enough to fix the conflict himself -
after all, I did :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Sep_2009_18_55_00_+1000_9WBe_oBUfVkAk1d4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkquBOQACgkQjjKRsyhoI8yqQwCfQMOTHDePoFMDj66w8PMvuLQO
c6UAniqTvQQwE+7re7LPP0NeCHjUvErz
=Xrzb
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Sep_2009_18_55_00_+1000_9WBe_oBUfVkAk1d4--
