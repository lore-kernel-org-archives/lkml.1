Return-Path: <linux-kernel-owner+w=401wt.eu-S1762856AbXGFKmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762856AbXGFKmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXGFKly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:41:54 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:58450 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbXGFKlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:41:53 -0400
Subject: Re: [PATCH 1/2] workqueue: debug flushing deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070705145243.GA189@tv-sign.ru>
References: <20070705110744.564273000@sipsolutions.net>
	 <20070705110820.304578000@sipsolutions.net>
	 <20070705143217.GA170@tv-sign.ru> <20070705144047.GA9548@elte.hu>
	 <20070705145243.GA189@tv-sign.ru>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BKopLc4shNQXFHQpx18+"
Date: Fri, 06 Jul 2007 12:42:41 +0200
Message-Id: <1183718561.3818.93.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BKopLc4shNQXFHQpx18+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-05 at 18:52 +0400, Oleg Nesterov wrote:

> So I agree with you, such recursion is indeed bad. Can we forbid this?
> In that case this patch is even more perfect :)

I haven't seen it complain in a few days so that probably means such
usage is rather rare :)

johannes

--=-BKopLc4shNQXFHQpx18+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjhyh/ETPhpq3jKURAtaXAKCPRHtGuRMDWEYp4ZqdwqJDD4UuNgCghcyL
Dyjkah7DM6BNHwG4fjg0t1o=
=kiFE
-----END PGP SIGNATURE-----

--=-BKopLc4shNQXFHQpx18+--

