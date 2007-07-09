Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbXGIUS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbXGIUS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbXGIUSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:18:37 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58372 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbXGIUSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:18:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Date: Mon, 9 Jul 2007 16:18:32 -0400
User-Agent: KMail/1.9.7
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070703221156.GY14825@petra.dvoda.cz> <20070706193514.GO17650@tasint.org> <4691E1DB.7050600@redhat.com>
In-Reply-To: <4691E1DB.7050600@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1463785.NvCHn0EJo3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707091618.39831.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1463785.NvCHn0EJo3
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 09 July 2007, Gerd Hoffmann wrote:
> Joel Becker wrote:
> > 	And if you think that all packages should Just Work on all
> > Linuxen, with out any build-time detection, try determining the
> > differing udev layouts of FC6, FC7, Debian, Ubuntu, SuSE9, SuSE10, etc.
>
> s/build/run/ time check IMHO.  Otherwise things blow up if the user
> upgrades fc6 to 7 ...

API's change, ABI's dont
-mike

--nextPart1463785.NvCHn0EJo3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARpKYH0FjO5/oN/WBAQJRvhAAlVcc9rfikVcv8mxcimcMKo8JhQSSeV5j
D7V2ogvRR74Cul78H8O0CMXWIndPVHlxdagOxlGMJFA4acjSR8CX+nxkeXa0HOBB
6j8g/ds8WCQzNHmWeFYWTz9SMB3+w+uFOu6EJKkd+c2f4uVzvH9sDZZ+qodU/qE+
L5jcVbz/z7qnqpvottk7ZtJMLwMGoECBK04S9JuPvqmoj2Yv948+Ai/CJ4THvPaE
hn8AEQVyowhzXOsjc09UCNErwCpv880LuBsi6cpTPrnk9NRe2LKQFpEm3TZzJy94
NljK4kYK0UIDDb8bDibwU78rskKIB5Tc2SbLsNwegcHzWCEnYVtF1FrvBKXaaEdG
Z2EAALp1LMt4Z0eY5N3EMOIv/WnNOA+h2FxZD1KVt0Uw5QhCgvMlX8Qm/pD1Ke1K
G7xRos/7S50E7q0sQzvIZlV7thCCGR9noGmLnVbprOh1h7KtkFuiHSZZleiP8DW7
ijFpf05KnVzpbxR1hceIZeCiWBQXsOAyoIvl+PYYcwHfWIF77GMS3IRfnr113cQf
xk+jKxj9Qci1pAxwYU8Z7WxoukD6JCxxseVVcNuhNn+hGxdIsFIRfQVYVeoFHUT7
rdD1B02jFrgb70gJBwXBQRZDNhO2QnOP6VqpiNP81StXtdoCsd4g0wat2h5WZJKq
XJqwBpD9iD8=
=6DMG
-----END PGP SIGNATURE-----

--nextPart1463785.NvCHn0EJo3--
