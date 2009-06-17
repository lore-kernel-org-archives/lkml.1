Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbZFQNz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbZFQNz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932412AbZFQNzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:55:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36163 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933314AbZFQNzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:55:50 -0400
Date: Wed, 17 Jun 2009 23:55:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: linux-next: kvm/powerpc tree build failure
Message-Id: <20090617235546.95aa39a5.sfr@canb.auug.org.au>
In-Reply-To: <4A38F47F.509@redhat.com>
References: <20090617150419.e406a69a.sfr@canb.auug.org.au>
	<4A38F47F.509@redhat.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Jun_2009_23_55_46_+1000_GyhvIH0i2ThtTBbK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Jun_2009_23_55_46_+1000_GyhvIH0i2ThtTBbK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Avi,

On Wed, 17 Jun 2009 16:49:51 +0300 Avi Kivity <avi@redhat.com> wrote:
>
> Thanks, applied.  For some reason my own build testing didn't fail on thi=
s.

Thanks.  It could be a different compiler version doesn't complain (I am
currently using 4.4.0) and the powerpc tree has a patch to build parts of
arch/powerpc with -Werror which makes it stand out a bit :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Jun_2009_23_55_46_+1000_GyhvIH0i2ThtTBbK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko49eIACgkQjjKRsyhoI8wnagCbBoNlSUAGVX48030lymGSm9Pe
fEAAnjef5ljG6Khkc4qz5+fYk4+kfWld
=ettf
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Jun_2009_23_55_46_+1000_GyhvIH0i2ThtTBbK--
