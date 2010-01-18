Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175Ab0ARIZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0ARIZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218Ab0ARIZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:25:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49051 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab0ARIZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:25:17 -0500
Date: Mon, 18 Jan 2010 19:25:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?UTF-8?B?TG/Dr2MgR3JlbmnDqQ==?= <loic.grenie@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] HOWTO: Updates on subsystem trees, patchwork,
 -next (vs.  -mm)
Message-Id: <20100118192508.fb9bacfb.sfr@canb.auug.org.au>
In-Reply-To: <tkrat.b7e388635b69af34@s5r6.in-berlin.de>
References: <4B4F7304.5050401@s5r6.in-berlin.de>
	<Pine.LNX.4.30.1001141303230.3979-100000@mail.perches.com>
	<tkrat.e8ba67441fb65247@s5r6.in-berlin.de>
	<9b06e8d21001141641u31c62480q706ed4fe122c7c20@mail.gmail.com>
	<tkrat.b7e388635b69af34@s5r6.in-berlin.de>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jan_2010_19_25_08_+1100_w5/z8pr7Q3Kpf5xo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jan_2010_19_25_08_+1100_w5/z8pr7Q3Kpf5xo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefan,

On Fri, 15 Jan 2010 13:23:51 +0100 (CET) Stefan Richter <stefanr@s5r6.in-be=
rlin.de> wrote:
>
> +2.6.x -next kernel tree for integration tests
> +---------------------------------------------
> +Before updates from subsystem trees are merged into the mainline 2.6.x
> +tree, they need to be integration-tested.  For this purpose, a special
> +testing repository exists into which virtually all subsystem trees are
> +pulled on an almost daily basis:
> +	http://git.kernel.org/?p=3Dlinux/kernel/git/sfr/linux-next.git

http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jan_2010_19_25_08_+1100_w5/z8pr7Q3Kpf5xo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktUGuQACgkQjjKRsyhoI8yzdACfavaFYEeZ/4p0sBEMRtp7hZFx
/HoAn06LyMzNxqCf8Qbu0qTF4Z5dB9AD
=zf/j
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jan_2010_19_25_08_+1100_w5/z8pr7Q3Kpf5xo--
