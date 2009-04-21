Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZDUSuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZDUSuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbZDUSuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:50:09 -0400
Received: from RedStar.dorchain.net ([212.88.133.153]:48614 "EHLO
	Redstar.dorchain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256AbZDUSuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:50:07 -0400
X-Greylist: delayed 1237 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Apr 2009 14:50:06 EDT
X-DKIM: Sendmail DKIM Filter v2.8.2 Redstar.dorchain.net n3LIPiYs019460
Date: Tue, 21 Apr 2009 20:25:41 +0200
From: Joerg Dorchain <joerg@dorchain.net>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       Joerg Dorchain <joerg@dorchain.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Tim Waugh <tim@cyberelk.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Pete Zaitcev <zaitcev@redhat.com>,
       Laurent Vivier <Laurent@lvivier.info>, unsik Kim <donari75@gmail.com>
Subject: Re: [PATCH 12/14] block: replace end_request() with
	[__]blk_end_request_cur()
Message-ID: <20090421182541.GJ6758@Redstar.dorchain.net>
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <1240331881-28218-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xGGVyNQdqA79rdfn"
Content-Disposition: inline
In-Reply-To: <1240331881-28218-13-git-send-email-tj@kernel.org>
X-message-flag: Please send message in plain text only.  Thanks!
X-Bindford: 6200 (more Power!)
X-Ray: beware
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xGGVyNQdqA79rdfn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2009 at 01:37:59AM +0900, Tejun Heo wrote:
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Joerg Dorchain <joerg@dorchain.net>

Acked-by: Joerg Dorchain <joerg@dorchain.net> (for amiflop.c)

--xGGVyNQdqA79rdfn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iHcEARECADcFAknuD6UwFIAAAAAAFQAScGthLWFkZHJlc3NAZ251cGcub3Jnam9l
cmdAZG9yY2hhaW4ubmV0AAoJEI2OPuD3c7zgadQAnRrDKf/wxaoZ4UVsrmNtUqSv
pHxiAJ9rIhxUWxWpV5AzDGEKDy6m07b+Xg==
=suBU
-----END PGP SIGNATURE-----

--xGGVyNQdqA79rdfn--
