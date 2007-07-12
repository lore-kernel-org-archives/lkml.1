Return-Path: <linux-kernel-owner+w=401wt.eu-S935281AbXGMJKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935281AbXGMJKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936182AbXGMJJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:09:59 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:58618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935918AbXGMJJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:09:57 -0400
Subject: Re: [2.6.23 PATCH 14/18] dm: netlink add to core
From: Johannes Berg <johannes@sipsolutions.net>
To: Mike Anderson <andmike@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070712004038.GB29241@us.ibm.com>
References: <20070711210159.GF24114@agk.fab.redhat.com>
	 <20070711143423.36722a41.akpm@linux-foundation.org>
	 <20070712004038.GB29241@us.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t9G3crkbNyLNjUqzEUPn"
Date: Fri, 13 Jul 2007 01:13:24 +0200
Message-Id: <1184282004.24418.1.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t9G3crkbNyLNjUqzEUPn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-11 at 17:40 -0700, Mike Anderson wrote:

> The pid is a hold over from older code. If this will cause issue for othe=
r
> users I can switch to using nlmsg_multicast (genlmsg_multicast depending
> on the comment if I need to switch to the genl interface) and remove this
> code all together.

Another possible genl multicast user :)

Has anybody had a chance to look at my patches for this?

johannes

--=-t9G3crkbNyLNjUqzEUPn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlrWT/ETPhpq3jKURAtPiAJ9606zXLNJMK7MjBx8vknr0Gk0oiQCfb6nh
QgdqwgpyBxaVVpRPSw8ATt8=
=bk+/
-----END PGP SIGNATURE-----

--=-t9G3crkbNyLNjUqzEUPn--

