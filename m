Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZGWDir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZGWDir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 23:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZGWDir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 23:38:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55355 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZGWDiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 23:38:46 -0400
Date: Thu, 23 Jul 2009 13:38:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next:  kgdb tree fetch failure
Message-Id: <20090723133842.30ae062b.sfr@canb.auug.org.au>
In-Reply-To: <4A67D36D.8070209@windriver.com>
References: <20090723090956.e6024af4.sfr@canb.auug.org.au>
	<4A67D36D.8070209@windriver.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Jul_2009_13_38_42_+1000_hy7h.x10UNgWkqCN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Jul_2009_13_38_42_+1000_hy7h.x10UNgWkqCN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Wed, 22 Jul 2009 22:05:17 -0500 Jason Wessel <jason.wessel@windriver.com=
> wrote:
>
> In the several years I have been using git, I have never seen it get
> corrupted until today.

Ouch!

> My local git repository completely bailed, so I am going to reconstruct
> the kgdb branches from a new clone.  There was no obvious way to recover
> my archive.=20

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Jul_2009_13_38_42_+1000_hy7h.x10UNgWkqCN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpn20IACgkQjjKRsyhoI8zDhwCfaFhgddOia3Z30R7l3xozOpRA
4AIAniJXDF0YquiBuopeiPoZKOJ/CxFM
=qgpb
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Jul_2009_13_38_42_+1000_hy7h.x10UNgWkqCN--
