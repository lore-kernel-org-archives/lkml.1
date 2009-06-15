Return-Path: <linux-kernel-owner+w=401wt.eu-S1765681AbZFOSbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765681AbZFOSbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759239AbZFOSbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:31:39 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:33920 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbZFOSbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:31:39 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 14:31:38 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=CZMelynubWwUp3SSSIgtBuaY5eht2eQhL6Ey9AR77sdauQH9wD+kW+HZYGIzULGGgT
         jRRKCHmB3G3fJfMOcc0XgFfI0aoxHHSW5TC8johyuzaJzIUr3Bn/2/ihHQNeTny8M9Y6
         GEp6qxCKQhBBI7PUVcWcdoURR5iVkExg0ySyE=
Message-ID: <4A369236.8070502@gmail.com>
Date: Mon, 15 Jun 2009 20:25:58 +0200
From: =?ISO-8859-1?Q?Sven_K=F6hler?= <sven.koehler@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090509)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: David Miller <davem@davemloft.net>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
References: <200906121344.26139.bzolnier@gmail.com>	<s5h7hzdew6u.wl%tiwai@suse.de>	<s5h63exevqh.wl%tiwai@suse.de>	<20090615.022547.107684868.davem@davemloft.net>	<s5hy6rtesjo.wl%tiwai@suse.de> <s5htz2hes3u.wl%tiwai@suse.de>
In-Reply-To: <s5htz2hes3u.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEE1CAA3B42D5ABE339D0D757"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEE1CAA3B42D5ABE339D0D757
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Takashi Iwai schrieb:
> Damn, that was buggy again.  The fixed version is below.

Seems to work fine.
I have been listening music fir quite a few minutes - skip free.


Thanks!

  Sven


--------------enigEE1CAA3B42D5ABE339D0D757
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko2kjYACgkQ7Ww7FjRBE4DseACgjsSvWIXeGZzBQlsHYcwxKOhz
KNgAnRs+LIFyY6OEcRg1uIYYZiE/mzuI
=BcA2
-----END PGP SIGNATURE-----

--------------enigEE1CAA3B42D5ABE339D0D757--
