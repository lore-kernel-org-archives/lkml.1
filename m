Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZFJGzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZFJGzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 02:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZFJGzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 02:55:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48504 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbZFJGzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 02:55:10 -0400
Date: Wed, 10 Jun 2009 16:55:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: kbuild tree build warning
Message-Id: <20090610165504.3047be39.sfr@canb.auug.org.au>
In-Reply-To: <20090610064723.GA25493@uranus.ravnborg.org>
References: <20090610115255.035da856.sfr@canb.auug.org.au>
	<20090610064723.GA25493@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Jun_2009_16_55_04_+1000_=G6wv_RFgIBHrUt3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jun_2009_16_55_04_+1000_=G6wv_RFgIBHrUt3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Wed, 10 Jun 2009 08:47:23 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> I already fixed this locally but I forgot to do a "git commit --amend" :-)
> Will be fixed in next push of kbuild-next.

Ah, well.  At least it was only a warning :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Jun_2009_16_55_04_+1000_=G6wv_RFgIBHrUt3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkovWMgACgkQjjKRsyhoI8y9HQCeIDkMrjoulNC4IMyDRm9CZMXR
JvcAnjLq5Av9dDVnskp3C7QQ+Ss6d01/
=HW93
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jun_2009_16_55_04_+1000_=G6wv_RFgIBHrUt3--
