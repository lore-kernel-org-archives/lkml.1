Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZBKCW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZBKCW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 21:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZBKCWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 21:22:47 -0500
Received: from home.keithp.com ([63.227.221.253]:37801 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbZBKCWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 21:22:47 -0500
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Feb 2009 21:22:47 EST
Subject: Re: [patch 05/56] agp/intel: Reduce extraneous PCI posting reads
	during init
From: Keith Packard <keithp@keithp.com>
To: Greg KH <gregkh@suse.de>
Cc: keithp@keithp.com, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@redhat.com>
In-Reply-To: <20090211002422.GF14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
	 <20090211002422.GF14660@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7JZ511tD+eTV1atAbhQS"
Date: Tue, 10 Feb 2009 18:13:42 -0800
Message-Id: <1234318422.11303.51.camel@aiko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7JZ511tD+eTV1atAbhQS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-10 at 16:24 -0800, Greg KH wrote:
> plain text document attachment
> (agp-intel-reduce-extraneous-pci-posting-reads-during-init.patch)
> 2.6.27-stable review patch.  If anyone has any objections, please let us =
know.

Not exactly a critical fix; more like a janitorial change, and only in
the start-up code path.

--=20
keith.packard@intel.com

--=-7JZ511tD+eTV1atAbhQS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJkjRWQp8BWwlsTdMRAmz1AJ9F37DekCHrOTxwUOKtQdc/ZRqNEgCg5qhq
eihyNOBEUW070wbtioBczVc=
=CxNL
-----END PGP SIGNATURE-----

--=-7JZ511tD+eTV1atAbhQS--

