Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYGNPgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYGNPgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYGNPfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:35:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36626 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbYGNPfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:35:51 -0400
Date: Tue, 15 Jul 2008 01:35:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] core/stacktrace changes for v2.6.27
Message-Id: <20080715013543.398c83d9.sfr@canb.auug.org.au>
In-Reply-To: <20080714144420.GA21632@elte.hu>
References: <20080714144420.GA21632@elte.hu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Jul_2008_01_35_43_+1000_yVlBtYzVNiZpUMsm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Jul_2008_01_35_43_+1000_yVlBtYzVNiZpUMsm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Mon, 14 Jul 2008 16:44:20 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> Please pull the latest core/stacktrace git tree from:
>=20
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git co=
re/stacktrace

This presumably needs the patch I posted today against linux-next that
fixes the powerpc allmodconfig build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Jul_2008_01_35_43_+1000_yVlBtYzVNiZpUMsm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh7ck8ACgkQjjKRsyhoI8wzTwCfez+KkSi+I+KE/cUWcyLI2qsi
RBkAoJ+CymzswKOsHvTKh6GMU0BgP45r
=lUZT
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Jul_2008_01_35_43_+1000_yVlBtYzVNiZpUMsm--
