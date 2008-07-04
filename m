Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbYGDNtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbYGDNtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYGDNth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:49:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58926 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbYGDNtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:49:36 -0400
Date: Fri, 4 Jul 2008 23:49:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 4
Message-Id: <20080704234929.f1b29844.sfr@canb.auug.org.au>
In-Reply-To: <20080704142302.0b536065@lxorguk.ukuu.org.uk>
References: <20080704195529.7f56e768.sfr@canb.auug.org.au>
	<20080704114648.13374869@lxorguk.ukuu.org.uk>
	<20080704231610.98118766.sfr@canb.auug.org.au>
	<20080704142302.0b536065@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Jul_2008_23_49_29_+1000_0TAoeB2GvCg8+FW_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Jul_2008_23_49_29_+1000_0TAoeB2GvCg8+FW_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Fri, 4 Jul 2008 14:23:02 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> > Good.  There are more broken drivers - check out
> > http://kisskb.ellerman.id.au/linux-next
>=20
> Yep
> =20
> > Were you using
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git or
> > http://www.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git ?  The
>=20
> git://

Weird, I wonder if it had only partially mirrored or something.  Does it
work for you now?  As a test, I created a new clone of Linus' tree and
fetched from both those URLs into that and they started ok.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Jul_2008_23_49_29_+1000_0TAoeB2GvCg8+FW_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhuKmkACgkQjjKRsyhoI8wAJgCgonpgZ/1ZUWW+ZZTUsI+47KHm
dagAnidz9dQub/Qi5s5nszyxuk0W6hrs
=WDb2
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Jul_2008_23_49_29_+1000_0TAoeB2GvCg8+FW_--
