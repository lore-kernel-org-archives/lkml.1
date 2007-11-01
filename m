Return-Path: <linux-kernel-owner+w=401wt.eu-S1760582AbXKAKJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582AbXKAKJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbXKAKJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:09:00 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:13609 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757251AbXKAKI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:08:59 -0400
Subject: Re: [PATCH 0/6] various scheduler patches
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20071101082915.GA8459@elte.hu>
References: <20071031211030.310581000@chello.nl>
	 <20071101082915.GA8459@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yD1O886O9vHvMwcViDL0"
Date: Thu, 01 Nov 2007 11:08:56 +0100
Message-Id: <1193911736.27652.248.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yD1O886O9vHvMwcViDL0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-11-01 at 09:29 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>=20
> > My current scheduler queue, seems to work well on lappy
>=20
> nice stuff! Both the hrtimers-tick feature and the rtlimit looks pretty=20
> good.=20

Thanks!

> I'm wondering how well it works on SMP?

It booted and seemed to properly compile a kernel on a dual core
opteron :-)

--=-yD1O886O9vHvMwcViDL0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHKaW4XA2jU0ANEf4RAv1kAKCMoqbBuqw1KNqn/mDTK5ckivNzXwCZAZxy
nKgyeDsT9qg8ICrNRKlfO6M=
=18ME
-----END PGP SIGNATURE-----

--=-yD1O886O9vHvMwcViDL0--

