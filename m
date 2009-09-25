Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbZIYDYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbZIYDYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 23:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZIYDYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 23:24:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46356 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbZIYDYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 23:24:48 -0400
Date: Fri, 25 Sep 2009 13:24:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs-client@lists.samba.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Subject: Re: linux-next: cifs tree build failures
Message-Id: <20090925132436.4de168bd.sfr@canb.auug.org.au>
In-Reply-To: <524f69650909242013r4d312204w9f8457c07db9dd24@mail.gmail.com>
References: <20090925095105.b06d77f3.sfr@canb.auug.org.au>
	<524f69650909242013r4d312204w9f8457c07db9dd24@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Sep_2009_13_24_36_+1000_ZUctlgkhC2APY5J="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Sep_2009_13_24_36_+1000_ZUctlgkhC2APY5J=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Thu, 24 Sep 2009 22:13:46 -0500 Steve French <smfrench@gmail.com> wrote:
>
> These now are fixed in cifs-2.6.git.   In the same patch found a minor
> locking problem which Jeff will fix tomorrow.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Sep_2009_13_24_36_+1000_ZUctlgkhC2APY5J=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkq8N/QACgkQjjKRsyhoI8y0HgCfUdeBHwpppkFcgdA517jOF4G6
EEEAnRBXPj2mKOJOjQgr5pBIHmYef+RT
=tHNV
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Sep_2009_13_24_36_+1000_ZUctlgkhC2APY5J=--
