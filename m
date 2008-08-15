Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbYHOPnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbYHOPnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbYHOPmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:42:53 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36028 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbYHOPmw (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:42:52 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Theodore Tso <tytso@mit.edu>
Cc: douglas.leeder@sophos.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforonaccess scanning
In-Reply-To: Your message of "Fri, 15 Aug 2008 09:55:37 EDT."
             <20080815135537.GN13048@mit.edu>
From: Valdis.Kletnieks@vt.edu
References: <20080815131621.GK13048@mit.edu> <20080815132227.6BF0431678F@pmx1.sophos.com>
            <20080815135537.GN13048@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1218814945_3568P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Aug 2008 11:42:26 -0400
Message-ID: <15589.1218814946@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1218814945_3568P
Content-Type: text/plain; charset=us-ascii

On Fri, 15 Aug 2008 09:55:37 EDT, Theodore Tso said:
> On Fri, Aug 15, 2008 at 02:22:27PM +0100, douglas.leeder@sophos.com wrote:
> > 
> > This is a problem for current anti-malware scanning, as virus data updates 
> > come every few hours
> 
> Every few hours?!?  I hadn't noticed Windows AV programs getting
> updates that frequently, at least not the ones that I've been familiar
> with.  (Semantec, Norton, McAfee)

Try running a mail server that provides virus scanning for a large population
of 100K or so mailboxes.  You end up pulling from your vendor on an hourly
basis, just because a virus on a burn through your userbase can toast you that
quickly.

Since 9AM Sunday (is now 11:30AM Friday as I write this), we've pulled new
signatures 33 times (one new signature each time in this case) from our vendor.
So yeah, about once every 3-4 hours we get a new updated one for a new variant
of whatever.  I've seen times when we've pulled a new signature file 3 hours in
a row, and each time there were 10-12 new variants, so averaging 12/hour...



--==_Exmh_1218814945_3568P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIpaPhcC3lWbTT17ARAiKqAKDKTDkXBYGmFJ5BKqihpzcUrfYrAACZAecZ
knRALDLwIi7gVSmDE42V2h4=
=eQb1
-----END PGP SIGNATURE-----

--==_Exmh_1218814945_3568P--
