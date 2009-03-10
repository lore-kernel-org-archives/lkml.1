Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZCJRuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZCJRuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZCJRt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:49:56 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:47777 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbZCJRtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:49:55 -0400
Subject: Re: [PATCH 00/31] *** SUBJECT HERE ***
From: Scott James Remnant <scott@canonical.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20090310184624.4e28d18e@hyperion.delvare>
References: <cover.1236702228.git.scott@canonical.com>
	 <20090310184624.4e28d18e@hyperion.delvare>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bxgtOn8YX5UoOSRCvrwP"
Date: Tue, 10 Mar 2009 17:49:51 +0000
Message-Id: <1236707391.6339.3.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bxgtOn8YX5UoOSRCvrwP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-10 at 18:46 +0100, Jean Delvare wrote:

> I don't get how it could make any difference in terms of performance.
> As far as I know, all the module aliases that come from the kernel are
> assembled into /lib/modules/$version/modules.alias when the kernel is
> installed, and that file must be processed by modprobe the exact same
> way another configuration file would. Or am I missing something?
>=20
With current modprobe those files are turned into a binary index that
can be read and processed *much* faster.

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-bxgtOn8YX5UoOSRCvrwP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm2qD8ACgkQSnQiFMl4yK7sWgCeIRHU8le8OfJy2YqmhN1T848x
MgQAnRzitLLP0f2+kTFiLyIfal8krbOG
=LKji
-----END PGP SIGNATURE-----

--=-bxgtOn8YX5UoOSRCvrwP--

