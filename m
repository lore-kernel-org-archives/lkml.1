Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZGZXYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZGZXYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZGZXYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:24:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55856 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbZGZXYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:24:49 -0400
Date: Mon, 27 Jul 2009 09:24:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
       Andrew Morton <akpm@linux-foundation.org>, drbd-dev@lists.linbit.com,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [Drbd-dev] [PATCH 00/16] drbd: a block device for HA clusters
Message-Id: <20090727092445.87a5a093.sfr@canb.auug.org.au>
In-Reply-To: <200907241720.22771.philipp.reisner@linbit.com>
References: <1246894775-10855-1-git-send-email-philipp.reisner@linbit.com>
	<20090721185156.GA10126@johann>
	<20090722145917.055eddc1.sfr@canb.auug.org.au>
	<200907241720.22771.philipp.reisner@linbit.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__27_Jul_2009_09_24_45_+1000_M/J4rs/JVfQn+Sli"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Jul_2009_09_24_45_+1000_M/J4rs/JVfQn+Sli
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Philipp,

On Fri, 24 Jul 2009 17:20:21 +0200 Philipp Reisner <philipp.reisner@linbit.=
com> wrote:
>
> Please add git://git.drbd.org/linux-2.6-drbd.git to linux-next.

I have added that tree from today.  Currently you are listed as the
contact (I can add others if you like).  I used the drbd branch of that
tree as the master branch appears to be Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__27_Jul_2009_09_24_45_+1000_M/J4rs/JVfQn+Sli
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkps5b0ACgkQjjKRsyhoI8zLjACfYjU5JKk6+JWDKuSRJwPRAqrN
GSwAoIdxECqtlDTG1TWbbFx9u7zvpQ8R
=al4e
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Jul_2009_09_24_45_+1000_M/J4rs/JVfQn+Sli--
