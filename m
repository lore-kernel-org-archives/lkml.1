Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZG3HI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZG3HI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 03:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZG3HI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 03:08:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40016 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZG3HI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 03:08:58 -0400
Date: Thu, 30 Jul 2009 17:08:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: linux-next: manual merge of the edac-amd tree with the rr tree
Message-Id: <20090730170850.6d777e96.sfr@canb.auug.org.au>
In-Reply-To: <20090730062309.GA15057@liondog.tnic>
References: <20090730154150.d4c326b5.sfr@canb.auug.org.au>
	<20090730062309.GA15057@liondog.tnic>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Jul_2009_17_08_50_+1000_1/VEQ4kLXH=0nOac"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jul_2009_17_08_50_+1000_1/VEQ4kLXH=0nOac
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Borislav,

On Thu, 30 Jul 2009 08:23:09 +0200 Borislav Petkov <petkovbb@googlemail.com=
> wrote:
>
> thanks for fixing that. Yep, the topology patches in the edac tree are
> not final yet, I've added them to the mix only because edac depends on
> the node_id functionality. I'll fix them up later against the rr stuff.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Jul_2009_17_08_50_+1000_1/VEQ4kLXH=0nOac
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpxRwIACgkQjjKRsyhoI8w2+wCgijLy3zqmCFJBDrt73h/fensD
ZyIAoJaaJXq7IoX8R03q0PTwZ8J9uKZc
=weBn
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jul_2009_17_08_50_+1000_1/VEQ4kLXH=0nOac--
