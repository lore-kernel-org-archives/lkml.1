Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbYGYFfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbYGYFfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 01:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYGYFfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 01:35:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47531 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYGYFfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 01:35:12 -0400
Date: Fri, 25 Jul 2008 15:35:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       David Altobelli <david.altobelli@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Let HP iLO driver depend on PCI
Message-Id: <20080725153502.283aae1f.sfr@canb.auug.org.au>
In-Reply-To: <20080724215652.24e4e550.akpm@linux-foundation.org>
References: <20080725022048.GB5179@osiris.boeblingen.de.ibm.com>
	<20080724215652.24e4e550.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Jul_2008_15_35_02_+1000__p/ocmeRbeSIB=p/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Jul_2008_15_35_02_+1000__p/ocmeRbeSIB=p/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 24 Jul 2008 21:56:52 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> Three weeks and nobody did an allmodconfig build on linux-next for s390
> or m68k (at least).

http://kisskb.ellerman.id.au/kisskb/branch/9/

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Jul_2008_15_35_02_+1000__p/ocmeRbeSIB=p/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiJZgYACgkQjjKRsyhoI8wA1QCeMSAmI8gqPNtOajelM4S1OWIn
ZR4AnjUdl/g9/0gDXwnGBmzzOFPKhwHg
=QtLA
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Jul_2008_15_35_02_+1000__p/ocmeRbeSIB=p/--
