Return-Path: <linux-kernel-owner+w=401wt.eu-S932951AbZFLILZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbZFLILZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762886AbZFLIKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:10:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46743 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762884AbZFLIKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:10:33 -0400
Date: Fri, 12 Jun 2009 18:10:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org, borislav.petkov@amd.com
Subject: Re: [GIT PULL] AMD64 EDAC module for 2.6.31
Message-Id: <20090612181022.8accf95b.sfr@canb.auug.org.au>
In-Reply-To: <20090612080323.GA14669@liondog.tnic>
References: <20090611103705.GC15454@aftab>
	<20090612080323.GA14669@liondog.tnic>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Jun_2009_18_10_22_+1000_uMlCf8+wMWK1NI9j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jun_2009_18_10_22_+1000_uMlCf8+wMWK1NI9j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Borislav,

On Fri, 12 Jun 2009 10:03:23 +0200 Borislav Petkov <petkovbb@googlemail.com=
> wrote:
>
> now that amd64 EDAC is upstream, I've removed the fox-next branch since
> the next patch series is not ready yet.
>=20
> What is actually the proper way to let you know that I don't have any
> more patches for linux-next right now and that you don't have to pull
> from my repo for now?

Just set the for-next branch to point somewhere in Linus' tree (where it
was would be fine if that is what Linus' merged from you).  That way I
can still try to fetch it each day and when you have new stuff, you can
just put it there without bothering to remember to tell me anything.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Jun_2009_18_10_22_+1000_uMlCf8+wMWK1NI9j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoyDW4ACgkQjjKRsyhoI8zPbgCfQ/WcD++GSIuhrvOwt3xiZDKx
jLYAn2HdQqIBQyur34fnyRskcgCw41q5
=63ax
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jun_2009_18_10_22_+1000_uMlCf8+wMWK1NI9j--
