Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYBRNPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYBRNPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYBRNPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:15:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59751 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYBRNPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:15:33 -0500
Date: Tue, 19 Feb 2008 00:15:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-Id: <20080219001526.bdb57549.sfr@canb.auug.org.au>
In-Reply-To: <4d8e3fd30802180311u1f216fe9va916e797db10af12@mail.gmail.com>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	<4d8e3fd30802180311u1f216fe9va916e797db10af12@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Feb_2008_00_15_26_+1100_.AnzKnzckauYVhzQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Feb_2008_00_15_26_+1100_.AnzKnzckauYVhzQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

On Mon, 18 Feb 2008 12:11:33 +0100 "Paolo Ciarrocchi" <paolo.ciarrocchi@gma=
il.com> wrote:
>
> I would like to update the "The development process" section in
> Documentation/HOWTO including some information about the linux-next tree.
>=20
> I understand what it's including but I didn't get how it will fit in
> the process.
> Is Linus going to pull from that tree as soon as we reach -rc0 or this
> is just a tree
> used for testing what will be pushed to Linus as soon as the two weeks
> merge window
> open?

The intention is the latter.  I hope to help people sort out some of the
conflicts and cross subsystem issues before we get into the merge window
and the code gets into Linus' tree.

Andrew Morton also hopes that the linux-next tree may get more testing
that the -mm tree did if we can stop it having to many regressions by
only including the less experimental code that is destined for the next
kernel release.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__19_Feb_2008_00_15_26_+1100_.AnzKnzckauYVhzQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHuYTzTgG2atn1QN8RAppnAJ4jtY/3HzgCp+BItONx3U6FXtZNvwCaA9w4
9XHpJ9iIvHdPwRxGruDMtv8=
=+x6W
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Feb_2008_00_15_26_+1100_.AnzKnzckauYVhzQ--
