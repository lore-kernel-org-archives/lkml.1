Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYHYO3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYHYO3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbYHYO3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:29:32 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:43167 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbYHYO3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:29:31 -0400
Date: Mon, 25 Aug 2008 10:27:02 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: 2 Q's on monitor power control
To: Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <200808251027.03109.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

I have a Samsung Synchmaster 205bw monitor, an LCD model, currently being 
driven by an ATI 9200SE video card.  I've noticed that the monitor is no 
longer being powered down at night or when I am absent for several hours.
This was working just fine until recently, so I may have turned something off 
in the .config that disabled this function.  Currently running 2.6.27-rc4. 
Uptime is a couple of days as I had to check something in the bios recently, 
which is not related to this AFAIK.

I use kde-3.5.9 and all that is setup and looks normal in kcontrol.

Is there an interface bit in /proc or /sys that I can write to to test this?

What specific options in the .config are required for this to work?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Where there's no emotion, there's no motive for violence.
		-- Spock, "Dagger of the Mind", stardate 2715.1
