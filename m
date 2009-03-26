Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbZCZV6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbZCZV6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 17:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932484AbZCZV56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 17:57:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52034 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396AbZCZV55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 17:57:57 -0400
Date: Fri, 27 Mar 2009 08:57:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       heiko.carstens@de.ibm.com
Subject: Re: Next March 26: s390 allnoconfig build failure still exists
Message-Id: <20090327085748.5422e4bc.sfr@canb.auug.org.au>
In-Reply-To: <49CB5165.4060401@in.ibm.com>
References: <20090326190130.54fc6fde.sfr@canb.auug.org.au>
	<49CB5165.4060401@in.ibm.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Mar_2009_08_57_48_+1100_f9OTUaIp8hy3H/Va"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Mar_2009_08_57_48_+1100_f9OTUaIp8hy3H/Va
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sachin,

On Thu, 26 Mar 2009 15:26:53 +0530 Sachin Sant <sachinp@in.ibm.com> wrote:
>
> I still see the following s390 allnoconfig build failure
> with today's next (and previous trees as well ).
>=20
> arch/s390/include/asm/smp.h:96: error: redefinition of smp_send_stop
> include/linux/smp.h:125: error: previous definition of smp_send_stop was =
here

There will be a fix for this in today's linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Mar_2009_08_57_48_+1100_f9OTUaIp8hy3H/Va
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknL+lwACgkQjjKRsyhoI8xUZgCfYUfOZTaSzNOQsBc+qa+eDq3m
BnkAn0KT2rfYJQLujCApks7DluEfGH0p
=sFtS
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Mar_2009_08_57_48_+1100_f9OTUaIp8hy3H/Va--
