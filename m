Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbZJZBFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbZJZBFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 21:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbZJZBFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 21:05:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59520 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbZJZBE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 21:04:59 -0400
Date: Mon, 26 Oct 2009 12:04:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-next@vger.kernel.org,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: writable limits to -next
Message-Id: <20091026120457.39f7ab83.sfr@canb.auug.org.au>
In-Reply-To: <m3eiorc7r4.fsf@intrepid.localdomain>
References: <4AC6339B.7000905@gmail.com>
	<20091006225751.7d5f3eec.sfr@canb.auug.org.au>
	<4AE16B0A.7020400@gmail.com>
	<20091026094741.5a1d492c.sfr@canb.auug.org.au>
	<m3eiorc7r4.fsf@intrepid.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__26_Oct_2009_12_04_57_+1100_mT4K+YDe6yHGZEsR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Oct_2009_12_04_57_+1100_mT4K+YDe6yHGZEsR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,

On Mon, 26 Oct 2009 01:35:11 +0100 Krzysztof Halasa <khc@pm.waw.pl> wrote:
>
> BTW you may want to check if the current wording is correct:
>=20
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>=20
> > You will need to ensure that the patches/commits in your tree/series ha=
ve
> > been:
> >      * submitted under GPL v2 (or later) and include the Contributor's
>          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> It's not ok to submit under e.g. GPL v3 only, I'd suggest "under GPL v2
> and optionally other licence(s)" or something like that.

Or maybe "under a license compatible with the Linux kernel source".

This was pointed out to me once before but I was hoping not to have to
disturb the IBM lawyers again.  I guess I will run it past them and see
what happens.

> For example code under BSD-style licence (in addition to GPLv2) is
> present in Linux, though I think any additional licence (the "later" as
> in "GPL v2 or later", GPL v3, MS EULA etc.) is acceptable as long as it
> is really additional, i.e., if one can ignore it and "use" GPLv2
> exclusively.
>=20
> IANAL of course.

Me neither :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Oct_2009_12_04_57_+1100_mT4K+YDe6yHGZEsR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrk9bkACgkQjjKRsyhoI8w0cQCeNRTlGwQgk1UdvgDmqvsu7zln
LTkAn2B4pdDvV0YD+FB6DVKnh2bUKgBx
=M5l4
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Oct_2009_12_04_57_+1100_mT4K+YDe6yHGZEsR--
