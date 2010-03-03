Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0CCAmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:42:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47289 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab0CCAmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:42:40 -0500
Date: Wed, 3 Mar 2010 11:42:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: build failure after merge of the ext3 tree
Message-Id: <20100303114231.c22db82e.sfr@canb.auug.org.au>
In-Reply-To: <20100302172757.GE3829@quack.suse.cz>
References: <20100302113634.2c7f5e03.sfr@canb.auug.org.au>
	<20100302172757.GE3829@quack.suse.cz>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Mar_2010_11_42_31_+1100_yHeXgCrZN7Cdd2Qb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Mar_2010_11_42_31_+1100_yHeXgCrZN7Cdd2Qb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

On Tue, 2 Mar 2010 18:27:57 +0100 Jan Kara <jack@suse.cz> wrote:
>
>   I'm sorry. It's my fault. I've modified Christoph's patch but I forgot =
to
> enable JFS in the test build. Since this isn't the first time something
> like this happened to me, I've changed the way I commit patches. They'll
> first go to for_testing branch and after a build machine runs them through
> allyesconfig and allmodconfig compiles they'll get moved to for_next
> branch. So hopefully stupid mistakes like this one should be avoided for
> future.

Sound like a good plan, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Mar_2010_11_42_31_+1100_yHeXgCrZN7Cdd2Qb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuNsHcACgkQjjKRsyhoI8wpxwCgnf9MwU5DCzNJX2oU1+Bwcnuj
nwIAoJM3Ev2EaxRijhMPNCIbq6mxx1pf
=egb/
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Mar_2010_11_42_31_+1100_yHeXgCrZN7Cdd2Qb--
