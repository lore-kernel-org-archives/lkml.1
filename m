Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbZEUNbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbZEUNbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbZEUNbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:31:19 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44253 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbZEUNbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:31:18 -0400
Message-ID: <4A155795.1080808@novell.com>
Date: Thu, 21 May 2009 09:31:01 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: avi@redhat.com
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au, kvm@vger.kernel.org
Subject: Re: [PATCH v2--refid=<20090521172122.bb12027c.sfr@canb.auug.org.au>]
 kvm: fix irqfd build failure discovered in linux-next
References: <20090521132723.8177.20321.stgit@dev.haskins.net>
In-Reply-To: <20090521132723.8177.20321.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig26D4387CF9FDBCDAAABC6139"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig26D4387CF9FDBCDAAABC6139
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Stephen Rothwell noted a build failure in arch !=3D x86 in last nights
> linux-next tree, as noted here:
>  =20

Typo on "stg-mail" command line caused the messed up subject above.  Pls
ignore this mail in favor of the real v2 resend that followed this.

-Greg



--------------enig26D4387CF9FDBCDAAABC6139
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoVV5UACgkQlOSOBdgZUxmIcgCeMvkt16nEQid5KvqmIRHUUhaF
JFAAn2noPlFuRDFyTiBsrdvhBoCVcVqO
=vRgB
-----END PGP SIGNATURE-----

--------------enig26D4387CF9FDBCDAAABC6139--
