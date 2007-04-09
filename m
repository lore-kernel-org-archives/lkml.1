Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXDIUdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXDIUdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965030AbXDIUdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:33:25 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55148 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810AbXDIUdY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:33:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jeff Garzik <jeff@garzik.org>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       John Stoffel <john@stoffel.org>
Subject: Re: I give up
In-Reply-To: Your message of "Mon, 09 Apr 2007 16:08:34 EDT."
             <461A9D42.9000008@garzik.org>
From: Valdis.Kletnieks@vt.edu
References: <200704091007.58535.gene.heskett@gmail.com> <200704091137.01336.gene.heskett@gmail.com> <17946.29660.368403.553290@smtp.charter.net> <200704091549.51805.gene.heskett@gmail.com>
            <461A9D42.9000008@garzik.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1176150799_3763P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Apr 2007 16:33:19 -0400
Message-ID: <6624.1176150799@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1176150799_3763P
Content-Type: text/plain; charset=us-ascii

On Mon, 09 Apr 2007 16:08:34 EDT, Jeff Garzik said:
> With current hard drive prices (200GB @ US$55, 500GB @ US$120) you can 
> just keep buying hard drives :)
> 
> Surely tape price/GB is higher than hard drive price/GB...

Erm. No.  We're in the middle of installing an StorageTek SL8500 for backups,
simply because an LTO3 tape holds 300G at a price point of $100 or so.
And there's no sane way to build a half-petabyte disk farm at that price.
(And yes, our tape backup service is well into the half-petabyte range, and
will probably shoot over that as soon as the SL8500 is in production and we
deal with all the backlogged requests for backup service).

Don't forget to factor in the cost of disk shelves, power, cooling, and all
that when you're building something to hold 2,500 200G drives.  Oh. and
controllers.  And machines to put the controllers in... and all the rest of it.

And remember - you *dont* want to be backing up critical data on the sort of
hard drives that cost $55 for 200G - you'll want multiple copies, probably
some RAID, etc etc.  

--==_Exmh_1176150799_3763P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGGqMPcC3lWbTT17ARAmtBAKDGjkg93Y8UaEnmJLb6MCJcJ19SjwCg7mo7
4O25OGPeilUTuDS1JaoPWgg=
=6kmR
-----END PGP SIGNATURE-----

--==_Exmh_1176150799_3763P--
