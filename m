Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbZIDI1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbZIDI1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932979AbZIDI1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:27:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42662 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616AbZIDI1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:27:45 -0400
Date: Fri, 4 Sep 2009 18:27:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: block tree build warning
Message-Id: <20090904182742.9b32a436.sfr@canb.auug.org.au>
In-Reply-To: <20090904075726.GS18599@kernel.dk>
References: <20090904175440.09a67ee7.sfr@canb.auug.org.au>
	<20090904075726.GS18599@kernel.dk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Sep_2009_18_27_42_+1000_jraVMOnC4P_7COOW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Sep_2009_18_27_42_+1000_jraVMOnC4P_7COOW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Fri, 4 Sep 2009 09:57:27 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> This is now fixed, I'll push out a new for-next in 2 seconds... And
> done, should be OK now.

Thanks, I will pick up this version (or whatever version you are up
to :-)) on Monday.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Sep_2009_18_27_42_+1000_jraVMOnC4P_7COOW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqgz34ACgkQjjKRsyhoI8wRcgCdEdlRJtxjn/sbkqwffcKhusaf
VkYAn27Yr260xT12tX69DRIx7xleITej
=gkA8
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Sep_2009_18_27_42_+1000_jraVMOnC4P_7COOW--
