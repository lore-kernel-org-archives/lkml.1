Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382Ab0ADNEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab0ADNEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 08:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169Ab0ADNEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 08:04:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47756 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab0ADNEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 08:04:33 -0500
Date: Tue, 5 Jan 2010 00:04:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: kgdb tree build failure
Message-Id: <20100105000427.b10232d3.sfr@canb.auug.org.au>
In-Reply-To: <4B41E542.40703@windriver.com>
References: <20100104164209.a5ac8d6a.sfr@canb.auug.org.au>
	<20100104164452.2803d62e.sfr@canb.auug.org.au>
	<4B41E542.40703@windriver.com>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Jan_2010_00_04_27_+1100_4TJ_B_jz+t74Sd7o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Jan_2010_00_04_27_+1100_4TJ_B_jz+t74Sd7o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Mon, 04 Jan 2010 06:55:30 -0600 Jason Wessel <jason.wessel@windriver.com=
> wrote:
>
> That patch could have been dropped from the series, but I did repair the
> problem.  I also added a 3 more config tests (sparc, arm and ppc) to my
> pre-submission test list.
>=20
> kgdb-next is updated and I can only hope the light is at the end of the
> tunnel for the config testing. :-)

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Jan_2010_00_04_27_+1100_4TJ_B_jz+t74Sd7o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktB51sACgkQjjKRsyhoI8w1eACeMG+bmTgNYur9VqMXXbp27YUi
J8AAoJM4JyMIlI+FcB/UJ+4Kij1kA4oh
=6Kvo
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Jan_2010_00_04_27_+1100_4TJ_B_jz+t74Sd7o--
