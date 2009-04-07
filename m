Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbZDGDmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbZDGDmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 23:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZDGDmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 23:42:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44053 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbZDGDmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 23:42:13 -0400
Date: Tue, 7 Apr 2009 13:42:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, perex@perex.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] sound updates for 2.6.30
Message-Id: <20090407134201.9c69ed4d.sfr@canb.auug.org.au>
In-Reply-To: <s5hskkli38v.wl%tiwai@suse.de>
References: <s5hskkli38v.wl%tiwai@suse.de>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Apr_2009_13_42_01_+1000_W5holYzc9HBsV8_U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Apr_2009_13_42_01_+1000_W5holYzc9HBsV8_U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

On Tue, 07 Apr 2009 04:53:04 +0200 Takashi Iwai <tiwai@suse.de> wrote:
>
> Peter Ujfalusi (3):
>       ASoC: TWL4030: Add constrains for second stream

This commit causes the linux-next tree to fail to build ... see my other
email.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Apr_2009_13_42_01_+1000_W5holYzc9HBsV8_U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknay4kACgkQjjKRsyhoI8zHMwCcDBg4rofDTxIf6i43CLB0BMOu
+B8AmwdRATbgqAMrPj8HHiT8wGcW3D7F
=+P+/
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Apr_2009_13_42_01_+1000_W5holYzc9HBsV8_U--
