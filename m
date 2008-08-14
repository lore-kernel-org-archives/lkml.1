Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYHNMP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYHNMP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 08:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYHNMPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 08:15:47 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:20330 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423AbYHNMPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 08:15:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgEABy/o0jCTsYx/2dsb2JhbACBYrRFgVU
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: linuxppc-dev@ozlabs.org, avorontsov@ru.mvista.com
Subject: Re: [PATCH 0/3] Patches to support QE USB Host Controller
Date: Thu, 14 Aug 2008 14:15:37 +0200
User-Agent: KMail/1.9.9
Cc: "Greg Kroah-Hartman" <greg@kroah.com>, linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, linux-kernel@vger.kernel.org,
       Timur Tabi <timur@freescale.com>
References: <20080808161717.GA19095@polina.dev.rtsoft.ru>
In-Reply-To: <20080808161717.GA19095@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart15632004.JyQgAgK3b9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808141415.42109.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart15632004.JyQgAgK3b9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 08 August 2008, Anton Vorontsov wrote:
> Hi all,
>=20
> Most patches that were needed to support QE USB Host were merged during
> 2.6.27 merge window, and only three more patches left over. Here they
> are.
>=20
> David, could you bear with gpio_to_chip() exported function, just as
> a stopgap for a proper api?

I need gpio_to_chip() (or another 'proper API') as well for RTS/CTS based f=
low control in the CPM/CPM2 UART driver.

Best regards,

=2D-=20
Laurent Pinchart
CSE Semaphore Belgium

Chaussee de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
=46 +32 (2) 387 42 75

--nextPart15632004.JyQgAgK3b9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkikIe4ACgkQ8y9gWxC9vpcmlACdE3MeY089shx+6b/k46phPYCA
LYIAoJ92hIim9i81dEaH+Q9m3raFDGRX
=tyOo
-----END PGP SIGNATURE-----

--nextPart15632004.JyQgAgK3b9--
