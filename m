Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbYKYJT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbYKYJT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYKYJTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:19:05 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:45729 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbYKYJTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:19:02 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] resource: allow MMIO exclusivity for device drivers
Date: Mon, 24 Nov 2008 15:01:34 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <20081123130302.22c197d5@infradead.org>
In-Reply-To: <20081123130302.22c197d5@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1357550.diyqYyYRa5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811241501.40545.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1357550.diyqYyYRa5
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Arjan van de Ven wrote:
> From 18cafd344e3de33b5e4feddac5657c1f5fed2d56 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Wed, 22 Oct 2008 19:55:31 -0700
> Subject: [PATCH] resource: allow MMIO exclusivity for device drivers
>
>  /**
> + *	pci_request_region - Reserved PCI I/O and memory resource
> + *	@pdev: PCI device whose resources are to be reserved
> + *	@bar: BAR to be reserved
> + *	@res_name: Name to be associated with resource.
> + *
> + *	Mark the PCI region associated with PCI device @pdev BR @bar as
                                                             ^^


> + *	Mark the PCI region associated with PCI device @pdev BR @bar as
                                                             ^^

Is this by intention or is there an 'A' missing?

Greetings,

Eike

--nextPart1357550.diyqYyYRa5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkqs8QACgkQXKSJPmm5/E7P0wCZAfX7049y0Wsbi+jkx1JAcFjN
8+8AoJpIZO+i9wubZvIA+B2O94C3WEDq
=8oCK
-----END PGP SIGNATURE-----

--nextPart1357550.diyqYyYRa5--
