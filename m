Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZG1Nf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZG1Nf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 09:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZG1Nfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 09:35:55 -0400
Received: from place.holder ([209.9.226.146]:46801 "EHLO grsecurity.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbZG1Nfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 09:35:54 -0400
Date: Tue, 28 Jul 2009 09:35:47 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James Morris <jmorris@namei.org>,
       James Carter <jwcart2@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, Stephen Smalley <sds@tycho.nsa.gov>,
       Daniel J Walsh <dwalsh@redhat.com>, cl@linux-foundation.org,
       Arjan van de Ven <arjan@infradead.org>, kees@outflux.net,
       Chad Sellers <csellers@tresys.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, mingo@elte.hu
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
Message-ID: <20090728133547.GA23858@grsecurity.net>
References: <1248132223.2654.278.camel@localhost> <alpine.LRH.2.00.0907211258110.32400@tundra.namei.org> <1248187482.19456.90.camel@moss-lions.epoch.ncsc.mil> <alpine.LRH.2.00.0907221953190.15799@tundra.namei.org> <20090728011943.589176cb@lxorguk.ukuu.org.uk> <87zlapgo2u.fsf@basil.nowhere.org> <20090728110028.31fa9a6f@lxorguk.ukuu.org.uk> <20090728112137.GF15310@basil.fritz.box>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20090728112137.GF15310@basil.fritz.box>
User-Agent: Mutt/1.5.9i
From: spender@grsecurity.net (Brad Spengler)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> If you use all available break points (making all gdb users unhappy)
> then you could still only cover 64 bytes on 64bit, 32 on 32bit.

Might want to double-check that math I think ;)

-Brad

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKbv6ymHm2SUJF1GoRAtUhAJ4jFj9fWk9XMhAr8wB9iAG1L1mhbgCdFT9w
8u8nna/ottq/y9tVDMD4kDA=
=UBYc
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
