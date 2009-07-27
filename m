Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbZG0Ju0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbZG0Ju0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbZG0Ju0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:50:26 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbZG0JuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:50:25 -0400
Subject: checkpatch suggestion
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Whitcroft <apw@shadowen.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gwKih1K5/3/LrFaGDSOa"
Date: Mon, 27 Jul 2009 11:50:27 +0200
Message-Id: <1248688227.19945.49.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gwKih1K5/3/LrFaGDSOa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Occasionally, but far more often than I'd like, we see user-visible
Kconfig symbols enter the tree that have no help text.

I don't know how easy/hard this is, but it'd be nice if checkpatch
caught those. Maybe that would reduce it somewhat.

johannes

--=-gwKih1K5/3/LrFaGDSOa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbXheAAoJEODzc/N7+Qma7iUP/2aBykYRGpx8tlvTLtNTqFZY
k/avulS1xHsYO/J5eONwRROwzVSo1l15zR/4tpWUtvdOEeWUKAOGQQxeFlb9G4bw
HXdaTUjvnnACSkdqxW4LK2sEvd4ztJIpw1TMnhBGU/5wHUcn2BURRQrAu08fPUPF
AaL8JlxZvPC8QMZppmTOtX1EibFGX/ch1L3JIbs7q8mOk50p7Ru3QhzDWTdQijm9
ARH/B5NLSGPbhnOH0DEimBlvVvqD3joSes2A6bVq87jxbXmE06WVhwlu+djCekfl
uGXajFeD21j399sCIZPpPHWlVG/0VAqCK37hNFCrfJLfBJP36psMDqPvh94mHLUT
mXyAsGpPcLMER1aYAb/uPZQotTvNr7kwTapy7gRTbERZnaZ6VKE5k6F1esZPuUhY
TMhlS2KHNcSwj+p7spW4mYt7a/3FQ+UgEkhWHRhVjoqGvRiUJ27biCnLzO4M5mfv
NMcydtB8hg9jfuXrdgp8VDDQkxx81GCEtS4ndWLOrMveE1fj6LmcVmMat4xX4F3J
+fDi0Ape/K87PWEDem4oeWq04pa9cbAsbY6d9KWdZaPdm2KrjRJ3GXRsqhvAX7O/
DF4uzNu/gUTOoAKKUdGObARVdc0UcddB5ANYUXxi++KU8DfqUi3kSeZDrb3hu4IS
NlqJsINruoC2PGAXeNW+
=wsut
-----END PGP SIGNATURE-----

--=-gwKih1K5/3/LrFaGDSOa--

