Return-Path: <linux-kernel-owner+w=401wt.eu-S1423417AbXD3Pkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423417AbXD3Pkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423416AbXD3Pkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:40:40 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:56639 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423417AbXD3Pkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:40:36 -0400
Subject: Re: [PATCH 28/36 #2] Use menuconfig objects II - sound
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Jaroslav Kysela <perex@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>
In-Reply-To: <Pine.LNX.4.61.0704301717300.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704301350460.29151@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704301717300.29151@yvahk01.tjqt.qr>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b7O054foWjKA7BczzptH"
Date: Mon, 30 Apr 2007 17:41:11 +0200
Message-Id: <1177947671.5102.103.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-b7O054foWjKA7BczzptH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-30 at 17:21 +0200, Jan Engelhardt wrote:

> Here's the updated thing wrt. AOA.

Looks good, thanks. There is the quirk that now you need the core module
if you want just i2sbus, but that's ok since i2sbus without the rest of
aoa is currently useless (it might become useful if we ever write a
modem driver, but that's probably not going to happen.)

So for the aoa part:
Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-b7O054foWjKA7BczzptH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGNg4X/ETPhpq3jKURAmRoAKCdXANHYwaNszxc4FalJaKDsZddBwCfRRYp
GNkn8cYi6/CPjTBEMNP4XVA=
=myiE
-----END PGP SIGNATURE-----

--=-b7O054foWjKA7BczzptH--

