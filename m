Return-Path: <linux-kernel-owner+w=401wt.eu-S964862AbXDQOM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbXDQOM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964974AbXDQOM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:12:58 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3227 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964862AbXDQOM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:12:57 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2007 10:12:57 EDT
Date: Tue, 17 Apr 2007 16:06:21 +0200
From: Erik Mouw <mouw@nl.linux.org>
To: Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>
Cc: Theodore Tso <tytso@mit.edu>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070417140621.GD22351@gateway.home>
References: <op.tqw1g6n0ftfxs2@localhost.localdomain> <20070417131045.GB18373@thunk.org> <Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2007 at 03:47:32PM +0200, Tomasz K?oczko wrote:
> On Tue, 17 Apr 2007, Theodore Tso wrote:
> [..]
> >Well, that was totally useless answer from the ZFS developers.  What
> >he should have told you is to contact Sun management, since they are
> >the only ones who can decide whether or not to release ZFS under a GPL
> >license, and more importantly, to give a patent license for any
> >patents they may have filed in the course of developing ZFS.  This is
> >not anything Linux developers can help you with.
>=20
> Realy can't or don't want (?)
> So who is responsible for potential changing Linux code licensing for=20
> allow if not incorporate CDDL code correct interraction without breaking=
=20
> some law ?

All Linux contributors (i.e: copyright owners) are. If you want to
change the kernel license, you have all contributors to agree. Like
somebody else in this thread already said: some of them can't be
reached anymore, some of them are even dead.

For Sun it would be much easier: there might be many contributors to
ZFS, but all of them are employed by Sun and hence Sun owns the
copyright and has the choice of license.

> And/or what Linux can loose on follow this king changes ?

A lot. Like an even playing field for all contributors.

> And/or why Linux code licensing can't evolve ? Seems when Linux code was=
=20
> licensed noone was thinking about case like interraction with code under=
=20
> license like CDDL so why now it can be corrected and still many people tr=
y=20
> to think like "anything arond Linux must evolve .. but not Linux" (?)

The Linux kernel was licensed under GPLv2 way before Sun even thought
about CDDL. You can't blame Linus for choosing a license that was
incompatible with to be written future licenses.

> Why this can't be fixes ?

Because so far we haven't found a way to ask dead copyright owners to
think about relicensing their code. And even if we had, that still
doesn't mean they would actually agree with relicensing their code.

> If in this ponit in Linux "evniroment" can't be chaged .. sorry but is it=
=20
> not kind of hipocritics ?

Nothing hypocritical about it, just undoable.


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJNRc/PlVHJtIto0RAnU0AJ90M6chbhD2FcRcO4wrLNZy47k5HwCfSEYj
9w2LtKKWOLkvH/faMVEfX0g=
=UFtX
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
