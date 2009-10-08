Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbZJHCgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbZJHCgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 22:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZJHCgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 22:36:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52597 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbZJHCgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 22:36:14 -0400
Date: Thu, 8 Oct 2009 13:35:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: Re: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20091008133529.eda6d568.sfr@canb.auug.org.au>
In-Reply-To: <20091006132857.5bd1cc3a.sfr@canb.auug.org.au>
References: <20091006132857.5bd1cc3a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__8_Oct_2009_13_35_29_+1100_2TqoJqJAu=dQykXL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Oct_2009_13_35_29_+1100_2TqoJqJAu=dQykXL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 6 Oct 2009 13:28:57 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the drm tree got a conflict in
> drivers/gpu/drm/radeon/radeon_device.c between commit
> 28d520433b6375740990ab99d69b0d0067fd656b ("drm/vgaarb: add VGA
> arbitration support to the drm and kms") from Linus' tree and commit
> 62a8ea3f7bb61e5f92db0a648b7cc566852c36ec ("drm/radeon/kms: Remove old
> init path as no hw use it anymore") from the drm tree.
>=20
> I have no idea how to reconcile these, so I have just used the version
> from the drm tree.  Please do the merge with Linus' tree and fix this up
> properly.  (There are also still conflicts in
> drivers/gpu/drm/radeon/radeon.h and drivers/gpu/drm/radeon/radeon_asic.h)

Got similar conflicts today ... any way you can sort this out, please?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__8_Oct_2009_13_35_29_+1100_2TqoJqJAu=dQykXL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrNT/EACgkQjjKRsyhoI8yQIQCeIgAF4twy8z9PZ90RzU1MrSpS
uisAn1xJ6uICfGagknMevuLavPHZ2+qR
=1oLs
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Oct_2009_13_35_29_+1100_2TqoJqJAu=dQykXL--
