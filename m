Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYABVvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYABVvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbYABVvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:51:42 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:17100 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbYABVvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:51:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=bj3leOX0benU/rMc8z9SXA/90I4h7Vf+SrxfnbVED4kTqg/p/4oLbcCnRbhkpFxUWuxyQDP3otnj7ch7gwn7ShlFapFaHx7w9vFmwCEmQAJyQ3u0YgORc36aGs2Mp44JDU6b8sdniG9yANLNJaqfnP1Q5CoQ09j5Z8R+aAj+W9Q=
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
From: Eric Anopolsky <erpo41@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080102195146.GB15898@does.not.exist>
References: <20080102013218.GO27566@does.not.exist>
	 <20080102174157.GD3351@webber.adilger.int>
	 <20080102195146.GB15898@does.not.exist>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XMu64o54CM2SRP122olD"
Date: Wed, 02 Jan 2008 13:51:32 -0800
Message-Id: <1199310692.5786.53.camel@dione>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XMu64o54CM2SRP122olD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> > Isn't CONFIG_EXPERIMENTAL enough?
>=20
> Most people and all distributions use CONFIG_EXPERIMENTAL=3Dy simply=20
> because too many options (including options required for hardware=20
> support) depend on it.

Maybe I'm wrong, but I think most people use the distro-provided
precompiled kernels. This is only a danger to people who insist on
compiling their own kernels but who don't know enough to investigate
things labeled "EXPERIMENTAL" before typing Y.

IMHO, these people are a dying breed since modern distros seem to do a
good job at preventing problems that drive ordinary users to compile
their own kernels in the first place. IMHO, it's reasonable to expect
the small minority of Linux users who want to compile their own kernels
to learn that "EXPERIMENTAL" means something.

Cheers,
Eric


--=-XMu64o54CM2SRP122olD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHfAdke2L37HVup3ARArSqAKDg09++/R8jwUIWZlL7fxBKUnWspwCeLiUY
ht/3UcAfTENpr7My3h+Mmk0=
=Z7oK
-----END PGP SIGNATURE-----

--=-XMu64o54CM2SRP122olD--

