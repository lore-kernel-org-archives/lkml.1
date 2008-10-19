Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbYJSBP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbYJSBP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 21:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYJSBPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 21:15:21 -0400
Received: from home.keithp.com ([63.227.221.253]:35053 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYJSBPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 21:15:20 -0400
Subject: Re: [git pull] drm patches for 2.6.27-rc1
From: Keith Packard <keithp@keithp.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: keithp@keithp.com, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <20081018180651.11b1d4a8@infradead.org>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <200810181237.49784.nickpiggin@yahoo.com.au>
	 <1224357062.4384.72.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu> <1224376691.4384.105.camel@koto.keithp.com>
	 <20081018180651.11b1d4a8@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9ZMAJlUStCNC0m4S6DTt"
Date: Sat, 18 Oct 2008 18:15:10 -0700
Message-Id: <1224378910.4384.114.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9ZMAJlUStCNC0m4S6DTt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-18 at 18:06 -0700, Arjan van de Ven wrote:

> how about pci_resource_force_caching(pci_dev, barnr, cachetype)?

and then 'pci_map_atomic'? Not sure this makes sense in the pci
namespace.

--=20
keith.packard@intel.com

--=-9ZMAJlUStCNC0m4S6DTt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI+ooeQp8BWwlsTdMRAqljAJ92ceYLcc6XcvjqCELK2hSkOruNzQCg60hf
DNy39S8Kab00n2b3fkm94JQ=
=JQb2
-----END PGP SIGNATURE-----

--=-9ZMAJlUStCNC0m4S6DTt--

