Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYJMGdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYJMGdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 02:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYJMGc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 02:32:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57896 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbYJMGc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 02:32:57 -0400
Date: Mon, 13 Oct 2008 17:32:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: /proc git tree
Message-Id: <20081013173248.9cc844c2.sfr@canb.auug.org.au>
In-Reply-To: <20081002212632.GA5852@x200.localdomain>
References: <20081002212632.GA5852@x200.localdomain>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__13_Oct_2008_17_32_48_+1100_xVhjq3mqPdXQ+T5n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Oct_2008_17_32_48_+1100_xVhjq3mqPdXQ+T5n
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexey,

On Fri, 3 Oct 2008 01:26:32 +0400 Alexey Dobriyan <adobriyan@gmail.com> wro=
te:
>
> Please, add the following to the list of poor souls:
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc
>=20
> So far it consists of 5 trivial patches from -mm, in future there will
> be smallish fs/proc/ reorganization, removing final defense line of ->rea=
d_proc()
> users and officially bug-free=C2=B9 examples of showing stuff via seq_fil=
es.

Added.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__13_Oct_2008_17_32_48_+1100_xVhjq3mqPdXQ+T5n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjy65AACgkQjjKRsyhoI8xHDwCfWcwH8Ip4E5WmZKS5EfU+fUs8
mLIAoJDDQZiLLVp30eCwnkQfvJ3v6ABt
=YRLu
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Oct_2008_17_32_48_+1100_xVhjq3mqPdXQ+T5n--
