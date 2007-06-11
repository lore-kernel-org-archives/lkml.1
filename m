Return-Path: <linux-kernel-owner+w=401wt.eu-S1763863AbXFKHiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763863AbXFKHiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 03:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbXFKHiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 03:38:12 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:48146 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbXFKHiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 03:38:11 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 34/54] Fix roundup_pow_of_two(1)
Date: Mon, 11 Jun 2007 09:38:17 +0200
User-Agent: KMail/1.9.7
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <20070608072127.352723000@sous-sol.org> <20070608081944.GA12687@thunk.org> <20070608182325.GH3723@sequoia.sous-sol.org>
In-Reply-To: <20070608182325.GH3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5603236.KTNfWSHCfO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706110938.19895.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5603236.KTNfWSHCfO
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Chris Wright wrote:
> * Theodore Tso (tytso@mit.edu) wrote:
> > If this doesn't fix a user-visiable bug, should we be including it in
> > the stable patch series?  (Assuming that it doesn't, I wouldn't, but I
> > tend to be more conservative about what I would include in a stable
> > production release.)
>
> Rolf, despite simplicity of patch, I'm inclined to agree with Ted.
> Were you effected by this in the wild, or just noticed by code
> inspection?

Code inspection. Drop it if you like, it's in mainline already.

--nextPart5603236.KTNfWSHCfO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGbPvrXKSJPmm5/E4RAoLPAJ4t80g0cJPFbSGWdmUkQE+gMp0xtACgkAYe
9Pf07LYmUizuw944Te9mfLg=
=zUss
-----END PGP SIGNATURE-----

--nextPart5603236.KTNfWSHCfO--
