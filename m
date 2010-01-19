Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048Ab0ASXt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0ASXt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017Ab0ASXt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:49:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50161 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab0ASXtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:49:24 -0500
Date: Wed, 20 Jan 2010 10:49:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Sachin Sant <sachinp@in.ibm.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [-next Jan 18] Boot failure on s390 with DEVTMPFS=y
Message-Id: <20100120104916.e1a2653e.sfr@canb.auug.org.au>
In-Reply-To: <20100119211422.GA10319@kroah.com>
References: <20100118195743.b45f119e.sfr@canb.auug.org.au>
	<4B546E7B.2080900@in.ibm.com>
	<ac3eb2511001180631r5209dff6s83ecdaee708e0b0b@mail.gmail.com>
	<20100119211422.GA10319@kroah.com>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jan_2010_10_49_16_+1100_YdH.d1HFjOPkHKsi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jan_2010_10_49_16_+1100_YdH.d1HFjOPkHKsi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 19 Jan 2010 13:14:22 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Mon, Jan 18, 2010 at 03:31:09PM +0100, Kay Sievers wrote:
> >=20
> > Heiko Carstens posted a simple patch to work around the issue that
> > s390 write-protects the string, the option parser tries to modify.
> > When Greg has pick it up, this should be fixed.
>=20
> Yes, I've now queued it up in my trees.

Great.  Another one bites the dust :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jan_2010_10_49_16_+1100_YdH.d1HFjOPkHKsi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktWRPwACgkQjjKRsyhoI8xMggCfUm1LRYqNAvL0GjpzcEG4NPVY
U8QAn3RuB7bpY1ApMJikSi7F4Fw5WuUl
=B4Ub
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jan_2010_10_49_16_+1100_YdH.d1HFjOPkHKsi--
