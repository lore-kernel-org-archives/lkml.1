Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbZACGTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbZACGTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 01:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZACGSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 01:18:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42874 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZACGSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 01:18:51 -0500
Date: Sat, 3 Jan 2009 17:18:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>, Chris Zankel <chris@zankel.net>,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       linux-am33-list@redhat.com, Hirokazu Takata <takata@linux-m32r.org>,
       linux-m32r@ml.linux-m32r.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: git-pull request for tip/cpus4096
Message-Id: <20090103171838.0610d443.sfr@canb.auug.org.au>
In-Reply-To: <200901031631.47818.rusty@rustcorp.com.au>
References: <495E4837.8090600@sgi.com>
	<20090102180942.GB10072@elte.hu>
	<200901031631.47818.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__3_Jan_2009_17_18_38_+1100_peNterqUCeb8cJn+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__3_Jan_2009_17_18_38_+1100_peNterqUCeb8cJn+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Sat, 3 Jan 2009 16:31:46 +1030 Rusty Russell <rusty@rustcorp.com.au> wro=
te:
>
> >  arch/cris           : 0
> >  arch/frv            : 0
> >  arch/h8300          : 0
> >  arch/m32r           : 0
> >  arch/m68k           : 0
> >  arch/mn10300        : 0
> >  arch/um             : 0
> >  arch/xtensa         : 0
>=20
> These are the non-linux-next archs.

linux-next does include (in theory) cris, m68k and xtensa.  I don't,
however, have a cris cross compiler.  And now I need a new sh cross
compiler. :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__3_Jan_2009_17_18_38_+1100_peNterqUCeb8cJn+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklfAz4ACgkQjjKRsyhoI8zZCQCgkWNRk5LXfExeuWce9zQC3vtm
zaIAoLhufPK7tj047QjpNF8f7Z0qcPdm
=w+bZ
-----END PGP SIGNATURE-----

--Signature=_Sat__3_Jan_2009_17_18_38_+1100_peNterqUCeb8cJn+--
