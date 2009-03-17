Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZCQXtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZCQXtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZCQXtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:49:33 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35231 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZCQXtd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:49:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Greg KH <gregkh@suse.de>
Cc: jkosina@suse.cz, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 29-rc-mmotm - HID/USB wedge w/ WARNING: at kernel/workqueue.c:371
In-Reply-To: Your message of "Tue, 17 Mar 2009 13:53:00 PDT."
             <20090317205300.GA4372@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <6648.1237271589@turing-police.cc.vt.edu>
            <20090317205300.GA4372@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1237333729_3640P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Mar 2009 19:48:49 -0400
Message-ID: <46594.1237333729@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1237333729_3640P
Content-Type: text/plain; charset=us-ascii

On Tue, 17 Mar 2009 13:53:00 PDT, Greg KH said:
> On Tue, Mar 17, 2009 at 02:33:09AM -0400, Valdis.Kletnieks@vt.edu wrote:
> > Yes, there's an NVidia driver loaded
> 
> Can you reproduce it without the nvidia driver loaded?

Now that I suspect the Targa cooling pad is the reproducer, I can probably
boot the box into single-user and wiggle the wire till it craps out.  Won't
happen till later tonight though.

--==_Exmh_1237333729_3640P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJwDbhcC3lWbTT17ARAumAAKD0WkuiEQx7AzTQFSkx6nTHgW5+OgCgpWIf
u/8KwpJ4RVH5WGQr1WkgUBg=
=QJ9m
-----END PGP SIGNATURE-----

--==_Exmh_1237333729_3640P--
