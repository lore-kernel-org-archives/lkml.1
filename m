Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYJVMot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYJVMot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYJVMoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:44:39 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:42103 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbYJVMoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:44:38 -0400
Subject: Re: Issue with e1000
From: Tony Vroon <tony@vroon.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <94a0d4530810220448x41241926r8f93cde4463b9864@mail.gmail.com>
References: <94a0d4530810220448x41241926r8f93cde4463b9864@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Vs2Rb2mmN4hCBraLTyFO"
Date: Wed, 22 Oct 2008 13:43:31 +0100
Message-Id: <1224679411.4001.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Vs2Rb2mmN4hCBraLTyFO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 14:48 +0300, Felipe Contreras wrote:
> I've been trying 2.6.27 and 2.6.27.2, and I haven't been able to use
> the e1000 module.

Perhaps your device is new enough to be PCI-express, and as such needs
the new e1000e driver? I would advise to have both drivers enabled or
modular, so you can try which one works.
(It is true that the e1000 driver attached to some PCIe hardware in the
past, this has been changed)

Regards,
Tony V.

--=-Vs2Rb2mmN4hCBraLTyFO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkj/H/IACgkQp5vW4rUFj5qVGwCcCUiu1Wie3Tyk3ZVNzke7AsSP
D6cAoIPOKBqWQpcObMm0111ab7hemqCX
=OvGX
-----END PGP SIGNATURE-----

--=-Vs2Rb2mmN4hCBraLTyFO--

