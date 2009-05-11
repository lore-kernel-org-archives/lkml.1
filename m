Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbZEKCiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbZEKCiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 22:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbZEKCil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 22:38:41 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50195 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZEKCik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 22:38:40 -0400
Subject: Re: [PATCH] mmc: Add fsl,esdhc as a valid compatible to bind
 against
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Kumar Gala <galak@kernel.crashing.org>
Cc: pierre@ossman.eu, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1241790769-3843-1-git-send-email-galak@kernel.crashing.org>
References: <1241790769-3843-1-git-send-email-galak@kernel.crashing.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-M1ErhluxqEqVgYsgIrEP"
Date: Mon, 11 May 2009 12:38:39 +1000
Message-Id: <1242009519.7767.44.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M1ErhluxqEqVgYsgIrEP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-08 at 08:52 -0500, Kumar Gala wrote:
> We plan to use fsl,esdhc going forward as the base compatible so update
> the driver to bind against it.

I was going to NAK this based on its non-sensical changelog, but going
backward you're not the first to be going forward :)

cheers


--=-M1ErhluxqEqVgYsgIrEP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoHj68ACgkQdSjSd0sB4dId0QCfapWMz/du/dhVKytbJqFwZs1+
S6oAoLfNypy4V6w9jvFUVxxy2GzosZhE
=RAy6
-----END PGP SIGNATURE-----

--=-M1ErhluxqEqVgYsgIrEP--

