Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbYL2LvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbYL2LvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYL2Lu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:50:59 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:53235 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYL2Lu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:50:59 -0500
Subject: Re: [RFC][PATCH] Notify init when processes are reparented to it
From: Scott James Remnant <scott@canonical.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081228220122.62940FC278@magilla.sf.frob.com>
References: <1230378128.7026.50.camel@quest>
	 <20081227114452.GA2919@zelda.netsplit.com>
	 <20081228092024.GA21673@redhat.com>
	 <20081228220122.62940FC278@magilla.sf.frob.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-X9w42mZm4PA6NM/h76YO"
Date: Mon, 29 Dec 2008 03:50:57 -0800
Message-Id: <1230551457.4664.0.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-X9w42mZm4PA6NM/h76YO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-28 at 14:01 -0800, Roland McGrath wrote:

> I'm highly skeptical that this is a desireable feature at all, and
> certainly I find the abuse of siginfo_t.si_status here extremely
> questionable.  I think we need a clear explanation of what problems
> the feature is intended to address.
>=20
Did the original e-mail not address this?

Scott

--=-X9w42mZm4PA6NM/h76YO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklYuZwACgkQSnQiFMl4yK54JACeN3L8YcYTs3NtGZthVN2vehZb
tLwAoKflejfd0gMm+dgWCBXPjQvRCNn1
=XgNV
-----END PGP SIGNATURE-----

--=-X9w42mZm4PA6NM/h76YO--

