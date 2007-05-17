Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbXEQNda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbXEQNda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 09:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXEQNdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 09:33:24 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:57069 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbXEQNdX (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 09:33:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ben Collins <ben.collins@ubuntu.com>
Cc: Greg KH <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net,
       Ganesh Varadarajan <ganesh@veritas.com>
Subject: Re: [linux-usb-devel] [PATCH] Remove duplicate ID in ipaq driver
In-Reply-To: Your message of "Thu, 17 May 2007 09:02:20 EDT."
             <1179406940.6510.90.camel@cunning>
From: Valdis.Kletnieks@vt.edu
References: <1179348840.6510.16.camel@cunning> <ada1whgmqlx.fsf@cisco.com> <1179351408.6510.24.camel@cunning> <20070517124333.GB20055@kroah.com>
            <1179406940.6510.90.camel@cunning>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1179408737_6207P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 17 May 2007 09:32:17 -0400
Message-ID: <17518.1179408737@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1179408737_6207P
Content-Type: text/plain; charset=us-ascii

On Thu, 17 May 2007 09:02:20 EDT, Ben Collins said:
> > So we just have to live with it, and the infinitesimal speed hit it
> > creates :)
> 
> Any objection to adding it to planned-for-removal and spitting out a
> printk when someone uses the "feature"?

Do we have any good reason to believe that this will eventually lead to
a clean-up?  ISTR that we did a similar printk for sysctl (or as Dr. Phil
likes to say, "How's that working for you?")


--==_Exmh_1179408737_6207P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGTFlhcC3lWbTT17ARAkWrAKDS0dlLEuNRhIWd/zxKIa5BzblkdACbBt4i
Wj2KlWjBHuQxNCalFrlTTDQ=
=GLub
-----END PGP SIGNATURE-----

--==_Exmh_1179408737_6207P--
