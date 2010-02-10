Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab0BJXLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 18:11:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40975 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab0BJXLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 18:11:11 -0500
Date: Thu, 11 Feb 2010 10:11:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       James Smart <james.smart@emulex.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
Message-Id: <20100211101103.04dc0735.sfr@canb.auug.org.au>
In-Reply-To: <1265840176.2769.576.camel@mulgrave.site>
References: <20100210123337.7a715aa0.sfr@canb.auug.org.au>
	<1265840176.2769.576.camel@mulgrave.site>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Feb_2010_10_11_03_+1100_+09O3D=+1KNj63Qw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Feb_2010_10_11_03_+1100_+09O3D=+1KNj63Qw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Wed, 10 Feb 2010 17:16:16 -0500 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> Sorry, my powerstation isn't working (orange warning light) and I can't
> seem to get anyone to repair it, so I can't build for ppc anymore (which
> is why this didn't get spotted on commit).

There are some (kernel building only) cross compilers at
http://bakeyournoodle.com/cross/ .  (yes, I know they are not PARISC
hosted :-))

That being said, I don't expect every maintainer to cross build very
much, just to react when they get problem reports. ;-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Feb_2010_10_11_03_+1100_+09O3D=+1KNj63Qw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktzPQcACgkQjjKRsyhoI8xSBwCeJBVM6l143XgaUGsOkmrLb7kH
uz8An1wDC51v0caLKKBJ27R4mP4rMK2b
=Qi8M
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Feb_2010_10_11_03_+1100_+09O3D=+1KNj63Qw--
