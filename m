Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbXKZQAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbXKZQAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbXKZQAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:00:31 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:51435 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbXKZQAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:00:30 -0500
Date: Mon, 26 Nov 2007 11:00:08 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Logwatch errors not very clear
To: linux-kernel@vger.kernel.org
Message-id: <200711261100.08512.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Running kernel 2.6.24-rc3 on an athlon xp-2800, 333 fsb.

>From logwatch:
 WARNING:  Kernel Errors Present
    [536447.736378] end_request: I/O error, dev hdc, sector ...:  1 Time(s)
    [536447.736383] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536447.736387] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536447.736390] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536447.736393] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536447.736395] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536447.736398] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536447.736400] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536447.736403] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536447.737645] end_request: I/O error, dev hdc, sector ...:  1 Time(s)
    [536447.737648] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536447.738516] end_request: I/O error, dev hdc, sector ...:  1 Time(s)
    [536447.738519] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536997.621727] end_request: I/O error, dev hdc, sector ...:  1 Time(s)
    [536997.621732] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536997.621736] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536997.621739] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536997.621741] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536997.621744] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536997.621747] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536997.621749] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536997.621752] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536997.622618] end_request: I/O error, dev hdc, sector ...:  1 Time(s)
    [536997.622621] Buffer I/O error on device hdc, l ...:  1 Time(s)
    [536997.623490] end_request: I/O error, dev hdc, sector ...:  1 Time(s)
    [536997.623492] Buffer I/O error on device hdc, l ...:  1 Time(s)
 
First time shown, uptime is 6d 16:26

Anybody care to comment?  hdc is my burner, and its been empty for several 
days now.   Can wine or cxoffice to that while looking for installable 
software?  I've been trying to make google sketchup work.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Work smarter, not harder, and be careful of your speling.
