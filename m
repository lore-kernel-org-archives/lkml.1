Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbXG0ASG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbXG0ASG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764319AbXG0ARz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:17:55 -0400
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:49522 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764285AbXG0ARx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:17:53 -0400
Message-ID: <46A939AF.50802@blueyonder.co.uk>
Date: Fri, 27 Jul 2007 01:17:51 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc1-git3 init failure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Boot failure on x86_64 (64X2), says it can't find init, specifically 
/init. 2.6.23-rc1-git1 boots and runs successfully. I haven't tried 
-git2. I shall reboot on 2.6.23-rc1-git3 tomorrow and record the full 
message.
Strings from vmlinux in both the above:-

Kernel alive
/dev/console
<4>Warning: unable to open an initial console.
<4>Failed to execute %s
<4>Failed to execute %s.  Attempting defaults...
/sbin/init
/etc/init
/bin/init
/bin/sh
No init found.  Try passing init= option to kernel.

Tried option "init=/sbin/init" and got the same failure.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


