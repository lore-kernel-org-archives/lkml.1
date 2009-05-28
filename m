Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZE1Esf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZE1Esf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 00:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZE1Es1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 00:48:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47473 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZE1Es0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 00:48:26 -0400
Date: Thu, 28 May 2009 14:48:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Tomas 'Sleep_Walker' Cech" <sleep_walker@suse.cz>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: pxa tree build failure
Message-Id: <20090528144820.6adf8426.sfr@canb.auug.org.au>
In-Reply-To: <f17812d70905271936x58f424deq583357279d24d78a@mail.gmail.com>
References: <20090528025406.781cfc0b.sfr@canb.auug.org.au>
	<f17812d70905271936x58f424deq583357279d24d78a@mail.gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_May_2009_14_48_20_+1000_UTi81NR=59Zj_HxH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_May_2009_14_48_20_+1000_UTi81NR=59Zj_HxH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Thu, 28 May 2009 10:36:19 +0800 Eric Miao <eric.y.miao@gmail.com> wrote:
>
> Yeah, that depends on the mach-types being updated, and we are
> still discussing about that. I'll temporarily move that commit off the
> branch, and put it back once ready.

Thanks for that.  For today, I have used the pxa tree from next-20090526
instead.  I will pick up your new tree tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_May_2009_14_48_20_+1000_UTi81NR=59Zj_HxH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoeF5QACgkQjjKRsyhoI8wadgCfQ9J+140eH17Vf7NVIVRiBEaa
iu4AoLlKWQ+2imJ3YpOAl/hilQtFsR7a
=lMS6
-----END PGP SIGNATURE-----

--Signature=_Thu__28_May_2009_14_48_20_+1000_UTi81NR=59Zj_HxH--
