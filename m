Return-Path: <linux-kernel-owner+w=401wt.eu-S1765828AbXKPVaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765828AbXKPVaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbXKPVaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:30:06 -0500
Received: from dns2.fullrate.dk ([89.150.129.10]:53463 "EHLO dns2.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbXKPVaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:30:05 -0500
X-Greylist: delayed 2153 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2007 16:30:04 EST
Message-ID: <473E815F.30900@minimum.se>
Date: Fri, 16 Nov 2007 21:51:27 -0800
From: Martin Olsson <mnemo@minimum.se>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ubuntu Devel Discuss <ubuntu-devel-discuss@lists.ubuntu.com>
Subject: Is it possible to give the user the option to cancel forkbombs?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel hackers,

This is a message from below 0x7FFFFFFF. Please look at this bug (it's 
not a new concept but still):
https://bugs.launchpad.net/ubuntu/+bug/163185

I'm no expert but I'd guess the "complete freeze" part of the bug has to 
do with the kernel, no? It would be nice to have a system which always 
lets me choose to abort stuff regardless of what kind of program mess I 
accidently started. Sort of like how you can "always" count on 
CTRL-ALT-DEL to work. Maybe it's possible to set some kind of 
MAX_PROCESS_COUNT for each user (I don't know) but it looks like this is 
not done by default in many distros today?

I mean, this effectively took down both my laptop and made the server of 
my shared web hosting company unresponsive for >10 mins (maybe it had 
some auto-reboot mechanism, I'm not sure).



		Martin
