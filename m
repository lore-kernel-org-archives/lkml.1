Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbYLZOES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbYLZOES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 09:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYLZOEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 09:04:10 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:40187 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYLZOEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 09:04:09 -0500
Date: Fri, 26 Dec 2008 09:05:22 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: removable media errors
To: linux-kernel@vger.kernel.org
Message-id: <200812260905.22062.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
Content-disposition: inline
User-Agent: KMail/1.9.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

I thought this was fixed as I hadn't seen it for a couple of rc's, but its 
back.

>From the log or logwatch:

 WARNING:  Kernel Errors Present
    [100771.466400] end_request: I/O error, dev fd0, sector ...:  1 Time(s)
    [100771.647800] end_request: I/O error, dev sr0, sector ...:  1 Time(s)
    [100771.647806] Buffer I/O error on device sr0, l ...:  1 Time(s)
    [100771.647809] Buffer I/O error on device sr0, l ...:  1 Time(s)
    [100771.649832] end_request: I/O error, dev sr0, sector ...:  1 Time(s)
    [100771.649834] Buffer I/O error on device sr0, l ...:  1 Time(s)
    [100771.649836] Buffer I/O error on device sr0, l ...:  1 Time(s)
    [100771.652022] end_request: I/O error, dev sr0, sector ...:  1 Time(s)
    [100771.652025] Buffer I/O error on device sr0, l ...:  1 Time(s)
    [100771.652027] Buffer I/O error on device sr0, l ...:  1 Time(s)
    [100771.652029] Buffer I/O error on device sr0, l ...:  1 Time(s)
    [100771.652031] Buffer I/O error on device sr0, l ...:  1 Time(s)
    [100771.652033] Buffer I/O error on device sr0, l ...:  1 Time(s)
    [100771.652035] Buffer I/O error on device sr0, l ...:  1 Time(s)
    [100771.657297] end_request: I/O error, dev sr0, sector ...:  1 Time(s)

There has not been any media in either drive since rebooting to 2.6.28 final.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Old soldiers never die.  Young ones do.
