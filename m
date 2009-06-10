Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbZFJJXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbZFJJXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbZFJJXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:23:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57327 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758573AbZFJJW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:22:59 -0400
Date: Wed, 10 Jun 2009 19:22:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: kbuild tree build warning
Message-Id: <20090610192255.b0dc29e8.sfr@canb.auug.org.au>
In-Reply-To: <20090610165504.3047be39.sfr@canb.auug.org.au>
References: <20090610115255.035da856.sfr@canb.auug.org.au>
	<20090610064723.GA25493@uranus.ravnborg.org>
	<20090610165504.3047be39.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Jun_2009_19_22_55_+1000_U41cm6Z_cSNDoW.P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jun_2009_19_22_55_+1000_U41cm6Z_cSNDoW.P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Wed, 10 Jun 2009 16:55:04 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Wed, 10 Jun 2009 08:47:23 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > I already fixed this locally but I forgot to do a "git commit --amend" =
:-)
> > Will be fixed in next push of kbuild-next.
>=20
> Ah, well.  At least it was only a warning :-)

One more:

include/asm-generic/vmlinux.lds.h:695:1: warning: "/*" within comment

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Jun_2009_19_22_55_+1000_U41cm6Z_cSNDoW.P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkove28ACgkQjjKRsyhoI8xP1QCeKjb+IACP+Sn2TCzVa9LDRuS1
m7IAn39TIgQ3ppgAdQ7tctdFNRh7U+RH
=FARO
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jun_2009_19_22_55_+1000_U41cm6Z_cSNDoW.P--
