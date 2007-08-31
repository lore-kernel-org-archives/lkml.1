Return-Path: <linux-kernel-owner+w=401wt.eu-S965707AbXHaO0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965707AbXHaO0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbXHaOZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:25:53 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43682 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbXHaOZw (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:25:52 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Rob Landley <rob@landley.net>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       bos@serpentine.com, werner@almesberger.net, hpa@zytor.com
Subject: Re: [PATCH] docs: ramdisk/initrd/initramfs corrections
In-Reply-To: Your message of "Thu, 30 Aug 2007 18:36:48 CDT."
             <200708301836.48707.rob@landley.net>
From: Valdis.Kletnieks@vt.edu
References: <20070830112055.2b2c8985.randy.dunlap@oracle.com> <Pine.LNX.4.64.0708301426360.4088@localhost.localdomain>
            <200708301836.48707.rob@landley.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188570311_3280P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 31 Aug 2007 10:25:11 -0400
Message-ID: <24556.1188570311@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188570311_3280P
Content-Type: text/plain; charset=us-ascii

On Thu, 30 Aug 2007 18:36:48 CDT, Rob Landley said:

> Could you mention it in feature-removal-schedule.txt?  (People check that for 
> warning of upcoming changes that impact existing code.  They may not notice
> something elsewhere after they've got it working...)
>
> (Also, sorting feature-removal-schedule.txt by date would be really nice.  The
> sucker's gotten huge...)

Maybe it's time we actually start heaving stuff over the side, especially
that stuff that the removal date has gone by?

What:   dev->power.power_state
When:   July 2007
What:   Video4Linux API 1 ioctls and video_decoder.h from Video devices.
When:   December 2006
What:   remove EXPORT_SYMBOL(kernel_thread)
When:   August 2006
What:   CONFIG_FORCED_INLINING
When:   June 2006
What:   eepro100 network driver
When:   January 2007

5 out of 26 things - close to 20% - is already overdue for nuking.  In some
cases, over a year overdue.

--==_Exmh_1188570311_3280P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG2CTHcC3lWbTT17ARAtEVAKCO4HPkSJ0gombU17Yye4JfbkvulQCdHOXh
L0De6K/X28IjVudPcUBcpo0=
=Qve/
-----END PGP SIGNATURE-----

--==_Exmh_1188570311_3280P--
