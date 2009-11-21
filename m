Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZKUBe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZKUBe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 20:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZKUBe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 20:34:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48654 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbZKUBe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 20:34:28 -0500
Date: Sat, 21 Nov 2009 12:34:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Vadim Mutilin <mutilin@ispras.ru>
Subject: Re: linux-next: manual merge of the staging tree with the pcmcia
 tree
Message-Id: <20091121123425.4c34be52.sfr@canb.auug.org.au>
In-Reply-To: <20091120182903.GB4804@kroah.com>
References: <20091109181544.454695c0.sfr@canb.auug.org.au>
	<20091120182903.GB4804@kroah.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__21_Nov_2009_12_34_25_+1100_NkIWr.JMq7Z8PPZw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__21_Nov_2009_12_34_25_+1100_NkIWr.JMq7Z8PPZw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Fri, 20 Nov 2009 10:29:03 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Mon, Nov 09, 2009 at 06:15:44PM +1100, Stephen Rothwell wrote:
> >=20
> > I fixed it up (using the pcmcia tree version when there is a clash) and
> > can carry the fix as necessary.
> >=20
> > [Greg, that staging tree commit has no SOB from its author ...]
>=20
> Good catch, I missed that :(
>=20
> I've now dropped this patch from my tree, so it should be fine now.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__21_Nov_2009_12_34_25_+1100_NkIWr.JMq7Z8PPZw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksHQ6EACgkQjjKRsyhoI8yphACggnOcvvGgkR683zJdgEryYUXL
vLcAoJtMfjC1zCqd13IabC3bFByboNFd
=N+4e
-----END PGP SIGNATURE-----

--Signature=_Sat__21_Nov_2009_12_34_25_+1100_NkIWr.JMq7Z8PPZw--
