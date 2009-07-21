Return-Path: <linux-kernel-owner+w=401wt.eu-S1751598AbZGUEJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbZGUEJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 00:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbZGUEJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 00:09:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37588 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZGUEJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 00:09:39 -0400
Date: Tue, 21 Jul 2009 14:09:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
       Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-Id: <20090721140934.4d36c616.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.01.0907201728170.19335@localhost.localdomain>
References: <20090720040813.GC11940@kroah.com>
	<200907201613.22483.wolfgang.walter@stwm.de>
	<20090720150916.GB10015@suse.de>
	<20090720180333.GA2905@brouette>
	<alpine.LFD.2.01.0907201110390.13838@localhost.localdomain>
	<20090721101355.c32a0d27.sfr@canb.auug.org.au>
	<alpine.LFD.2.01.0907201728170.19335@localhost.localdomain>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Jul_2009_14_09_34_+1000_VzkOZZL+Wyc9tJ_c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Jul_2009_14_09_34_+1000_VzkOZZL+Wyc9tJ_c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 20 Jul 2009 17:28:49 -0700 (PDT) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> On Tue, 21 Jul 2009, Stephen Rothwell wrote:
> >=20
> > ccache includes, in the hash of the preprocessed file, "the real compil=
ers
> > size and modification time", so will probably notice an upgrade or
> > downgrade of the compiler.
>=20
> Including something like the assembler? Apparently the problem here was=20

No.

> binutils.

Yeah, difficult as ccache really doesn't know what assembler will be used.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Jul_2009_14_09_34_+1000_VzkOZZL+Wyc9tJ_c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkplP34ACgkQjjKRsyhoI8yErwCeOWkFyPaieYHtWlAJ8rcfJlhR
upsAoIijSdE9Hw97cDpd59UlklO+0kYn
=Kzwi
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Jul_2009_14_09_34_+1000_VzkOZZL+Wyc9tJ_c--
