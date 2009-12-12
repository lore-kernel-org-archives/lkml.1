Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZLLG4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZLLG4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 01:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZLLG4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 01:56:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60916 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZLLG4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 01:56:42 -0500
Date: Sat, 12 Dec 2009 17:56:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb_autopm_*() removal build failure...
Message-Id: <20091212175642.364e5734.sfr@canb.auug.org.au>
In-Reply-To: <20091211.214714.41966763.davem@davemloft.net>
References: <20091211.174551.123151540.davem@davemloft.net>
	<20091212040524.GA11212@suse.de>
	<20091211.214714.41966763.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__12_Dec_2009_17_56_42_+1100_.xJoufU5m6VdNsCQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__12_Dec_2009_17_56_42_+1100_.xJoufU5m6VdNsCQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Fri, 11 Dec 2009 21:47:14 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> This also means you weren't doing allmodconfig builds on your USB tree
> this entire time, because if you had you would have realized that this
> fix belonged there not in net-2.6 :-)  And if the USB bits were
> going in via -next I'm really surprised Stephen Rothwell wasn't
> complaining about this too :)

I did - a posting on Dec 9 with subject "linux-next: staging tree build
failure" (which should have been "usb tree" - and I corrected that).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__12_Dec_2009_17_56_42_+1100_.xJoufU5m6VdNsCQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksjPqoACgkQjjKRsyhoI8zd+QCeK6X3omsOs0Olx9/+kX8UToVh
JEIAni3ViflkHkgf7QR6iNvjPDB+O0Lq
=I7Sp
-----END PGP SIGNATURE-----

--Signature=_Sat__12_Dec_2009_17_56_42_+1100_.xJoufU5m6VdNsCQ--
