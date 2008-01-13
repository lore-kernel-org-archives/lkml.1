Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbYAMPGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYAMPGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 10:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYAMPFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 10:05:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:53684 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYAMPFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 10:05:52 -0500
Date: Sun, 13 Jan 2008 16:05:36 +0100
From: Mario Guenterberg <mg@havelsoft.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: iwlwifi 1.2.23 vs. kernel 2.6.23.13
Message-ID: <20080113150536.GA27544@/bin/dnsdomainname>
Reply-To: linux-wireless@vger.kernel.org
Mail-Followup-To: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
Organization: havelsoft.com
X-Operating-System: GNU/Linux (Kernel 2.6.23.13-z61m)
X-PGP-Key: http://www.havelsoft.com/misc/mg_pubkey.asc
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Provags-ID: V01U2FsdGVkX181cMsDQ/l6zgrR1N1RyPqQyL5nXsUDr2LxMzC
 +p21163ALDjNVOE7YJigjlmKnbVwZpFz8OIiH1p0ALtqVovZzj
 GzenrfWz+LufxIkZbtk1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi...

I has tried to compile the latest stable kernel (2.6.23.13) with the
iwlwifi-1.2.23 driver and the mac80211-10.0.4 framework. I has
patched the kernel source tree and when I start menuconfig, it was fine.
If I started to run make, nothing seems to be wrong, but the iwl3945
module was not build.

I don't know why this module doesn't build anymore!

On kernel 2.6.23.12 with iwlwifi-1.1.19 and mac80211-9.0.3 I has no
problems like above.

regards
Mario

--=20
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS/CM d- s++: a+ C++++>$ UBL*++++$ P++ L+++ E--- W+++ N+ o-- K- w O- M-
V-- PS++ PE++ Y PGP+++ t--- 5 X++++ R++ tv- b+++ DI D++++  G++ e* h----
r+++ y++++
------END GEEK CODE BLOCK------

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQIVAwUBR4oovzUZahlMISn3AQJTQw//Q0GeS2NI1Y9DrZWTiaQP7i3cr9mNyGoI
ZBYSBNqPsDT2Tz4Kai3YNbmcXrXvK+YTlGmJIWAWttCFCT+Zv+W1J01NmSGz1gGn
nI/uOaRjs2xkcxGsHDp16L0bm4q0Te1KuA0uXpEgPjpkXsIVr8VoGjmyFpBNmkTk
9Iic/39jMVd3EvlUenP8SbfxFjZVyC7eFNk8krE8ryyQw82t9I6RXKYu40zGHVYF
NF/hPbJ4HsKI7PPFmPDPSg++txwsnGcJsPmqmr1ZwNCxb7wkLf8I65SPRcdEuHC8
P2Mgwj12ghM/1NoByx6tbkwrFxXn2d4fXw9hyryo+NucEMr9e8LpqW4Aa2kpThMy
29lTS49JBERHznLqbOUnBjN1Ex0FTp/bY/IxhUionzam/wjA+5577KducQQRl4jg
kW9mOWcrPTVEWJS9jTyWekQuFI7okRztKniOcc/MiMwCsrHNluCvjJsovGFoorli
ysrGchP4NPc6H8iSNd01QoOlm6bM5T18f4Ij8+YReawcUpnUCwWyF0SaaFpF06Uu
dQn/YHn21pcOFHLq+ew6Xovs+BcH1UEEq2c8vjkHBKfnlrvhr6cR+GQLwrsPY12g
eDbbJ6Uxmcq3ufx0EMltuToFxCwZuGDNlepD6lzrdM+It4vQvZBKlo6hH1y5Bqcm
g3UM0vugIiI=
=+8BK
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
