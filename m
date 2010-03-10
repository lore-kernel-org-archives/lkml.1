Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab0CJWFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:05:39 -0500
Received: from deliverator4.gatech.edu ([130.207.160.70]:59066 "EHLO
	deliverator4.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785Ab0CJWFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:05:37 -0500
Date: Wed, 10 Mar 2010 17:05:26 -0500
From: Evan McClain <evan.mcclain@gatech.edu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: rpurdie@rpsys.net, akpm@linux-foundation.org, schwalbe@inf.tu-dresden.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: mbp_nvidia_bl - add five more MacBook
 variants
Message-ID: <20100310220526.GA24941@macbook.site>
References: <1268180458-1844-1-git-send-email-evan.mcclain@gatech.edu>
 <20100310142424.GA21625@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20100310142424.GA21625@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 10, 2010 at 02:24:24PM +0000, Matthew Garrett wrote:
> Acked in principle, but at this point it probably needs to be renamed=20
> and have the Kconfig entry updated if it's going to be used for other=20
> hardware. Does it actually work on non-nvidia Macs?

I have applied it locally and tested on my MacBook 3,1 for several weeks
now. The intel X driver requires a small patch to use the mbp_backlight
class, but I'll let them know once this patch has been applied upstream.

There are several bugreports related to this issue at the ubuntu,
opensuse, and freedesktop bugzillas (see
https://bugzilla.novell.com/show_bug.cgi?id=3D581474 with links to the
other reports as well).

Thanks
--=20
Evan McClain
Aerospace Engineering
Graduate Student Senator  .
evan.mcclain@gatech.edu  ..:

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iHwEABECADwFAkuYF6Y1FIAAAAAAFQAXcGthLWFkZHJlc3NAZ251cGcub3JnZXZh
bi5tY2NsYWluQGdhdGVjaC5lZHUACgkQvbxY5xzjycBbuQCgzHNXR02R3m2idEQh
XrfnlemUK3wAmwZBM+YNxRFL4PSgd6JIfLfW9g/H
=c5Tf
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
