Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZFZEPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZFZEPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 00:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbZFZEPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 00:15:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35577 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZFZEPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 00:15:21 -0400
Date: Fri, 26 Jun 2009 14:15:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Dike <jdike@addtoit.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Boaz Harrosh <bharrosh@panasas.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
Message-Id: <20090626141515.c45bb6bf.sfr@canb.auug.org.au>
In-Reply-To: <20090626024802.GA17655@c2.user-mode-linux.org>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com>
	<4A3F4448.30502@panasas.com>
	<20090622085735.GB6499@cr0.nay.redhat.com>
	<20090622205226.fee30ba8.sfr@canb.auug.org.au>
	<20090625104901.GG6374@cr0.nay.redhat.com>
	<20090625145155.GA6383@c2.user-mode-linux.org>
	<20090626120111.ef8622ba.sfr@canb.auug.org.au>
	<20090626024802.GA17655@c2.user-mode-linux.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Jun_2009_14_15_15_+1000_Pj9QeQ_=DAHHBFON"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jun_2009_14_15_15_+1000_Pj9QeQ_=DAHHBFON
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

On Thu, 25 Jun 2009 22:48:02 -0400 Jeff Dike <jdike@addtoit.com> wrote:
>
> defconfig is good - that's my normal test config.
>=20
> > Currently plain "make ARCH=3Dum" on PowerPC doesn't appear to work.
>=20
> No, it won't.

OK, thanks.

For reference, the result of our nightly builds (for UML) can be found
here: http://kisskb.ellerman.id.au/kisskb/compiler/26/ (we are only
building Linus' tree and linux-next).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Jun_2009_14_15_15_+1000_Pj9QeQ_=DAHHBFON
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpES1MACgkQjjKRsyhoI8yraQCeKuG0jrFEhCDYQ4o/QgTKB2Ws
KB0AnAivvTrLAEdWls/QFbatWyPQjZaa
=SB9W
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jun_2009_14_15_15_+1000_Pj9QeQ_=DAHHBFON--
