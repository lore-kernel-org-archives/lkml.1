Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbXEFHQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbXEFHQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 03:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbXEFHQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 03:16:42 -0400
Received: from h80ad2754.async.vt.edu ([128.173.39.84]:49371 "EHLO
	h80ad2754.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbXEFHQm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 03:16:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Christoph Hellwig <hch@infradead.org>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: VMware, x86_64 and 2.6.21.
In-Reply-To: Your message of "Sat, 05 May 2007 10:56:09 BST."
             <20070505095609.GB9935@infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <1177998147.8981.16.camel@nigel.suspend2.net> <1178031475.3448.0.camel@laptopd505.fenrus.org> <1178032456.13953.12.camel@nigel.suspend2.net>
            <20070505095609.GB9935@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178435773_3690P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 06 May 2007 03:16:13 -0400
Message-ID: <18248.1178435773@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178435773_3690P
Content-Type: text/plain; charset=us-ascii

On Sat, 05 May 2007 10:56:09 BST, Christoph Hellwig said:
> On Wed, May 02, 2007 at 01:14:16AM +1000, Nigel Cunningham wrote:
> > > if you want to ask questions about proprietary kernel stuff you're
> > > better off asking the vendor directly, not lkml
> > 
> > I did, but given that it the failure only appeared with a change of
> > vanilla kernel version, I didn't think it was out of place to ask here
> > too.
> 
> No, it's still totally offtopic here.

I'm not convinced it's *totally* off-topic.  I'll agree that third-party
binaries are on their own as far as active support goes, but I don't see
that it's off-topic to post a simple statement-of-fact like "2.6.mumble-rc1
breaks <popular-driver-FOO>" just so it's a *known* issue and people who
search the list archives don't spend forever re-inventing the wheel.  Also,
it's quite *possible* that the binary module has tripped over a geniune
regression or bug in the kernel.

--==_Exmh_1178435773_3690P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGPYC9cC3lWbTT17ARAlIWAJ45KmWFmcjZZjFoIh0mf3ES1gByWwCff8YQ
DnqzLf+q3hlyr5eprMyAtoE=
=4A9E
-----END PGP SIGNATURE-----

--==_Exmh_1178435773_3690P--
