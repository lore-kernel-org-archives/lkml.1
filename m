Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYFZCCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYFZCCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 22:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYFZCCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 22:02:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41460 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbYFZCCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 22:02:37 -0400
Date: Thu, 26 Jun 2008 12:02:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel-testers@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for June 25
Message-Id: <20080626120212.c8caa005.sfr@canb.auug.org.au>
In-Reply-To: <200806260228.38674.rjw@sisk.pl>
References: <20080626003554.b2623aba.sfr@canb.auug.org.au>
	<200806260228.38674.rjw@sisk.pl>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Jun_2008_12_02_12_+1000_vtaUkFvpL134Dlba"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Jun_2008_12_02_12_+1000_vtaUkFvpL134Dlba
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

On Thu, 26 Jun 2008 02:28:38 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> This tree is completely broken on my test box (x86-64 HP nx6325) and I ca=
n't
> even bisect it. :-(

Config?

> It hits a NULL pointer dereference in find_symbol during boot, but when I=
 tried
> to bisect this issue, I hit another one that made the box hang solid duri=
ng
> boot (early, no messages available).
>=20
> If things continue going this way, 2.6.27 will be a disaster ...

None of us want that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Jun_2008_12_02_12_+1000_vtaUkFvpL134Dlba
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhi+KUACgkQTgG2atn1QN94SgCfXJSPJ0Xx0vYGQOXgrLQYXBxg
l30An0LROxAdBf+61O4kr4Sv31qPRR1b
=TQcQ
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Jun_2008_12_02_12_+1000_vtaUkFvpL134Dlba--
