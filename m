Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYKTXed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYKTXed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 18:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYKTXeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 18:34:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48564 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbYKTXeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 18:34:23 -0500
Date: Fri, 21 Nov 2008 10:34:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Richard A. Holden III" <aciddeath@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unused variables from the cirrusfb driver
Message-Id: <20081121103409.fed9a837.sfr@canb.auug.org.au>
In-Reply-To: <1227204203-32112-2-git-send-email-aciddeath@gmail.com>
References: <1227204203-32112-1-git-send-email-aciddeath@gmail.com>
	<1227204203-32112-2-git-send-email-aciddeath@gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__21_Nov_2008_10_34_09_+1100_o/BJIl1SY+1qXpfe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Nov_2008_10_34_09_+1100_o/BJIl1SY+1qXpfe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Thu, 20 Nov 2008 11:03:22 -0700 "Richard A. Holden III" <aciddeath@gmail=
.com> wrote:
>
> Remove i and s vars from cirrusfb_setup as they are not used
> anywhere in that function. This fixes 2 unused vars build warnings.

Thanks for the patch, but this is already fixed in mainline (commit
ee11940f8e7a2f064af22d52180cb5f9643eef61 "cirrusfb: remove unused
variables").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__21_Nov_2008_10_34_09_+1100_o/BJIl1SY+1qXpfe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkl8/EACgkQjjKRsyhoI8watQCfeQli2t8ue5fIuXqaqPjNg6fZ
6WQAn0oqpkpQVgOw928jAL7S+9w2xXjF
=yc7T
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Nov_2008_10_34_09_+1100_o/BJIl1SY+1qXpfe--
