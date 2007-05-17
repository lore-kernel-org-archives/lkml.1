Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbXEQVUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbXEQVUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbXEQVUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:20:04 -0400
Received: from nammta.apcc.com ([159.215.21.91]:2420 "EHLO nammta.apcc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548AbXEQVUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:20:03 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 17:20:03 EDT
Subject: question on msdos support
To: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 6.5.2 June 01, 2004
Message-ID: <OFC29C8BAB.491598A7-ON852572DE.007320AA-852572DE.0073CEA7@apcc.com>
From: Mike.Johnson@apc.com
Date: Thu, 17 May 2007 17:04:57 -0400
MIME-Version: 1.0
X-MIMETrack: Serialize by Router on Mako/NAM/APCC at 05/17/2007 05:04:59 PM,
	Itemize by SMTP Server on NAMMTA/APCMTA at 05/17/2007 05:04:59 PM,
	Serialize by Router on NAMMTA/APCMTA at 05/17/2007 05:20:06 PM,
	Serialize complete at 05/17/2007 05:20:06 PM
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Whoever responds to this mail, please email me directly....thank-you!

It seems that the dos file system does not work correctly with kernel
version 2.6.12. When using a dos formatted usb memory stick and placing
files onto the memory stick, the files are corrupt.

All the data is there in the file, but it has been mixed up. The first 2k
of the file is fine, followed by what should be the 3 k of data, but
instead is the 6-8k of data....and so on.

Any thoughts on patches that may have fixed this...or where I can go to
search for patch information would be helpful

Thanks,

Mike

Michael Johnson
American Power Conversion
132 Fairgrounds Road
West Kingston, RI  02892
tele: (401) 789 - 5735 x2982


Other must-visit sites include...

http://www.datacenteruniversity.com
http://www.bladeready.com
http://www.gutor.com
http://www.netbotz.com
http://www.availability.com

