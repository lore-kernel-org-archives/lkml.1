Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbZGHXmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbZGHXmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 19:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZGHXmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 19:42:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45257 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbZGHXmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 19:42:44 -0400
Date: Thu, 9 Jul 2009 09:42:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the wireless tree with the
 net-current tree
Message-Id: <20090709094233.77232ec3.sfr@canb.auug.org.au>
In-Reply-To: <20090708140425.GE4253@tuxdriver.com>
References: <20090708124005.ecbf2907.sfr@canb.auug.org.au>
	<20090708140425.GE4253@tuxdriver.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Jul_2009_09_42_33_+1000_bjStxCOLiue8Q.ko"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Jul_2009_09_42_33_+1000_bjStxCOLiue8Q.ko
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Wed, 8 Jul 2009 10:04:25 -0400 "John W. Linville" <linville@tuxdriver.co=
m> wrote:
>
> There is some code reorganization happening in wireless-next-2.6,
> resulting in a couple of files getting deleted.  I'm guessing that
> if/when Dave pulls net-2.6 into net-next-2.6 (which wireless-next-2.6
> gets rebased upon) then this should resolve itself.

Indeed, that is why I ignored the problem for now.  I was just flagging
that the issue will need to be resolved at some point.  (Although I am
assuming that ignoring the fix in net-current does not produce too much
bad fallout right now.)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__9_Jul_2009_09_42_33_+1000_bjStxCOLiue8Q.ko
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpVLukACgkQjjKRsyhoI8z5LwCgh681d8eQQ59xuCSxt1eeOIQS
GSsAoIyryHX8dRQbYv+QzSOo7tEg3C5d
=xr1W
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Jul_2009_09_42_33_+1000_bjStxCOLiue8Q.ko--
