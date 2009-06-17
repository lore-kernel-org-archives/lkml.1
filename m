Return-Path: <linux-kernel-owner+w=401wt.eu-S1765651AbZFQNKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765651AbZFQNKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761874AbZFQNKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:10:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49905 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763407AbZFQNKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:10:38 -0400
Date: Wed, 17 Jun 2009 23:10:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
       geert@linux-m68k.org
Subject: Re: linux-next: net tree build failure
Message-Id: <20090617231034.16717d14.sfr@canb.auug.org.au>
In-Reply-To: <20090617.013658.58706664.davem@davemloft.net>
References: <20090617163112.e14e064d.sfr@canb.auug.org.au>
	<20090617.013658.58706664.davem@davemloft.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Jun_2009_23_10_34_+1000_C2+kOpxXKcwE9X+H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Jun_2009_23_10_34_+1000_C2+kOpxXKcwE9X+H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 17 Jun 2009 01:36:58 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> I just pushed the following fix, thanks!
>=20
> sonic: Fix build after ndo_start_xmit() changes.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Jun_2009_23_10_34_+1000_C2+kOpxXKcwE9X+H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko460oACgkQjjKRsyhoI8whBACeKIHOKEuKOKvkHkhHCLc5Ci4R
phAAn1VMl4/HSanshzB8gThdhWz322Kr
=hjOH
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Jun_2009_23_10_34_+1000_C2+kOpxXKcwE9X+H--
