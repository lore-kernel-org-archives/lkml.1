Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYGCPLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYGCPLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYGCPLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:11:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47401 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYGCPLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:11:16 -0400
Date: Fri, 4 Jul 2008 01:11:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Generic HDLC next tree
Message-Id: <20080704011110.bcc42858.sfr@canb.auug.org.au>
In-Reply-To: <m3hcb7njh4.fsf@maximus.localdomain>
References: <m3hcb7njh4.fsf@maximus.localdomain>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Jul_2008_01_11_10_+1000_nlOX5uabB=WPmUp0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Jul_2008_01_11_10_+1000_nlOX5uabB=WPmUp0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,

On Thu, 03 Jul 2008 16:13:59 +0200 Krzysztof Halasa <khc@pm.waw.pl> wrote:
>
> I've setup a generic HDLC "next" tree (currently for 2.6.27) at
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git hdlc-ne=
xt
>=20
> This branch can be rebased or recreated at any time, hope it's ok for
> "next". Currently based on 2.6.26-rc8.
>=20
> Could you please include it in your "next" process?

I have added that tree starting from tomorrow.

Thanks for joining.

Usual speech I give everybody: changes must be posted somewhere relevant,
reviewed, unit tested and destined for 2.6.27.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Jul_2008_01_11_10_+1000_nlOX5uabB=WPmUp0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhs7A4ACgkQjjKRsyhoI8wbKwCgq5UOrhSCOjgwJA8LSKrReBxe
aQ8AnRHDnRziqA0TQA5aawmRJZkDCg4v
=7eOQ
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Jul_2008_01_11_10_+1000_nlOX5uabB=WPmUp0--
