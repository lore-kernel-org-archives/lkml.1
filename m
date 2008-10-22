Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYJVNnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYJVNnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYJVNne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:43:34 -0400
Received: from clegg.madduck.net ([193.242.105.96]:53245 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbYJVNnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:43:33 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 09:43:33 EDT
Date: Wed, 22 Oct 2008 15:33:13 +0200
From: martin f krafft <madduck@madduck.net>
To: linux-kernel@vger.kernel.org
Subject: Re: File as generic block-device?
Message-ID: <20081022133313.GA26243@piper.oerlikon.madduck.net>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <48FF2304.8070301@dolphinics.no>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <48FF2304.8070301@dolphinics.no>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux lenny/sid kernel 2.6.26-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Simen Thoresen <simentt@dolphinics.no> [2008.10.22.1456 +0200]:
> accept a file as a block-device, but I have found no such function
> for  mdadm, and am thus asking for a kernel-internal way to
> re-plug a file  into the block-device layer.

I suggest you search the web first.
http://en.wikipedia.org/wiki/Loopback_disk_device

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"you don't sew with a fork, so i see no reason
 to eat with knitting needles."
                               -- miss piggy, on eating chinese food
=20
spamtraps: madduck.bogus@madduck.net

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj/K5kACgkQIgvIgzMMSnU3ZwCdF+17jkf/ZVetCZzSYv/Pnph7
64AAoLyYYgYlqW5k6Nh5uQzjNi7BKNkA
=QQlk
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
