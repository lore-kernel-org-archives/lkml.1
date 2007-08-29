Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbXH2P6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbXH2P6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 11:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXH2P6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 11:58:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:23363 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbXH2P6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 11:58:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,322,1183359600"; 
   d="asc'?scan'208";a="122966174"
Subject: Re: CFS review
From: Keith Packard <keith.packard@intel.com>
Reply-To: keith.packard@intel.com
To: Ingo Molnar <mingo@elte.hu>
Cc: keith.packard@intel.com, Al Boldi <a1426z@gawab.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070829080417.GB19386@elte.hu>
References: <200708111344.42934.a1426z@gawab.com>
	 <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu>
	 <200708280737.53439.a1426z@gawab.com> <20070829041827.GA8733@elte.hu>
	 <1188361749.21502.123.camel@koto.keithp.com>
	 <20070829044614.GA13225@elte.hu>
	 <1188374249.21502.155.camel@koto.keithp.com>
	 <20070829080417.GB19386@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cbPIFDblAg63NyvMNXLW"
Organization: Intel Corp
Date: Wed, 29 Aug 2007 08:57:55 -0700
Message-Id: <1188403075.21502.158.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cbPIFDblAg63NyvMNXLW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-29 at 10:04 +0200, Ingo Molnar wrote:

> is that old enough to not have the smart X scheduler?

The smart scheduler went into the server in like 2000. I don't think
you've got any systems that old. XFree86 4.1 or 4.2, I can't remember
which.

> (probably=20
> the GLX bug you mentioned) so i cannot reproduce the bug.

With X server 1.3, I'm getting consistent crashes with two glxgear
instances running. So, if you're getting any output, it's better than my
situation.

--=20
keith.packard@intel.com

--=-cbPIFDblAg63NyvMNXLW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG1ZeDQp8BWwlsTdMRAq5GAKChT+V9ngAJ1zmMaTzTq0sqkp4JdQCdF7kY
3tA9ZD3uLLi5WVYbR8/Bujw=
=XqYG
-----END PGP SIGNATURE-----

--=-cbPIFDblAg63NyvMNXLW--
