Return-Path: <linux-kernel-owner+w=401wt.eu-S935609AbYGCHM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935609AbYGCHM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbYGCG6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41236 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbYGCFpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 01:45:25 -0400
Date: Thu, 3 Jul 2008 15:45:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, vda.linux@googlemail.com,
       linux-arch@vger.kernel.org, rmk@arm.linux.org.uk, dhowells@redhat.com,
       ralf@linux-mips.org, kernel@wantstofly.org, jwboyer@linux.vnet.ibm.com,
       paulus@samba.org, dwmw2@infradead.org, torvalds@linux-foundation.org,
       paul.gortmaker@windriver.com, linux-embedded@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com,
       schwidefsky@de.ibm.com, davem@davemloft.net
Subject: Re: [PATCH 21/23] make section names compatible with
 -ffunction-sections -fdata-sections: v850
Message-Id: <20080703154512.8aae68ae.sfr@canb.auug.org.au>
In-Reply-To: <200807030017.53747.arnd@arndb.de>
References: <200807020242.21960.vda.linux@googlemail.com>
	<20080702145859.a9af30ea.akpm@linux-foundation.org>
	<486BFC21.1040001@firstfloor.org>
	<200807030017.53747.arnd@arndb.de>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Jul_2008_15_45_12_+1000_wavV4XOqtDABxZGi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Jul_2008_15_45_12_+1000_wavV4XOqtDABxZGi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Jul 2008 00:17:52 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thursday 03 July 2008, Andi Kleen wrote:
> > Same seems to be true for cris btw.
>=20
> Cris has seen significant updates in 2.6.25 by its maintainer.
> It's not a very active port, but skipping updates for one kernel
> version is on a completely different scale from doing nothing
> at all for over three years as in the v850 case.

Also, cris has a tree in linux-next now, so there will be updates in 2.6.27.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Jul_2008_15_45_12_+1000_wavV4XOqtDABxZGi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhsZ2gACgkQjjKRsyhoI8zW4wCbBHlOYz/v5rXuJUwe+oni1mfV
irsAoKsvbpYV3Ou8gqTf62Y9ZoKpfXWn
=6aOm
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Jul_2008_15_45_12_+1000_wavV4XOqtDABxZGi--
