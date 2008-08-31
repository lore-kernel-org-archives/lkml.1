Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbYHaTu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbYHaTu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 15:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbYHaTuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 15:50:14 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:57809 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756124AbYHaTuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 15:50:12 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Tom Tucker <tom@opengridcomputing.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       John Ronciak <john.ronciak@gmail.com>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, linux-nfs@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net
In-Reply-To: <20080831194609.GC14876@fieldses.org>
References: <1219605422.14389.2.camel@localhost>
	 <1219605596.14389.5.camel@localhost>
	 <1219615789.27921.152.camel@localhost.localdomain>
	 <1219616136.14389.12.camel@localhost>
	 <48B2D7F8.5020206@opengridcomputing.com>
	 <20080826192711.GJ4380@fieldses.org>
	 <48B567F5.2090605@opengridcomputing.com>
	 <1220111261.31172.14.camel@localhost.localdomain>
	 <20080831193037.GB14876@fieldses.org>
	 <1220211842.31172.18.camel@localhost.localdomain>
	 <20080831194609.GC14876@fieldses.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-niQGmczhGTdoddGjhTCO"
Date: Sun, 31 Aug 2008 20:49:13 +0100
Message-Id: <1220212153.31172.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-niQGmczhGTdoddGjhTCO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-08-31 at 15:46 -0400, J. Bruce Fields wrote:
> Yes.  It's the server side we're interested in, by the way--are you
> collecting this deubgging on the client?

Er, yeah, since the client appeared to be the problem.

I'll try again on the server!

Ian.
--=20
Ian Campbell

The descent to Hades is the same from every place.
		-- Anaxagoras

--=-niQGmczhGTdoddGjhTCO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAki69bkACgkQM0+0qS9rzVklXACgmAYGxBgg2HS6RR/9KRxm0J4K
W+MAmgNcLUcB5n4Lp33Jy+jGo4SlOtmq
=+QJm
-----END PGP SIGNATURE-----

--=-niQGmczhGTdoddGjhTCO--

