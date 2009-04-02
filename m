Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbZDBMwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbZDBMwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbZDBMw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:52:27 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45243 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbZDBMw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:52:26 -0400
Message-ID: <49D4B594.6080703@novell.com>
Date: Thu, 02 Apr 2009 08:54:44 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <87ab71monw.fsf@basil.nowhere.org> <49D35825.3050001@novell.com> <20090401132340.GT11935@one.firstfloor.org> <49D37805.1060301@novell.com> <20090401170103.GU11935@one.firstfloor.org> <49D3B64F.6070703@codemonkey.ws> <49D3D7EE.4080202@novell.com> <49D46089.5040204@redhat.com> <49D497A1.4090900@novell.com> <49D4A4EB.8020105@redhat.com> <49D4AE0C.3000604@novell.com> <49D4B2C0.5060906@redhat.com>
In-Reply-To: <49D4B2C0.5060906@redhat.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig18F179FA9E4ABDD3019C67C7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig18F179FA9E4ABDD3019C67C7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
>
>
> My 'prohibitively expensive' is true only if you exit every packet.
>
>

Understood, but yet you need to do this if you want something like iSCSI
READ transactions to have as low-latency as possible.

-Greg



--------------enig18F179FA9E4ABDD3019C67C7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknUtZQACgkQlOSOBdgZUxk7fACeKEOKjQ0GkJx71C1DAPlbamWg
fkIAnAsWOmX65hcniuEECUeQirGFFR2p
=/EvJ
-----END PGP SIGNATURE-----

--------------enig18F179FA9E4ABDD3019C67C7--
