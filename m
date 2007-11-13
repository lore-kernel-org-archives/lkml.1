Return-Path: <linux-kernel-owner+w=401wt.eu-S1762320AbXKMUpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762320AbXKMUpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759599AbXKMUpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:45:21 -0500
Received: from smtp02.colorado.edu ([128.138.128.142]:40850 "EHLO
	smtp02.Colorado.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874AbXKMUpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:45:20 -0500
X-Greylist: delayed 1184 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 15:45:20 EST
X-ASG-Debug-ID: 1194985533-5acd010f0000-xx1T2L
X-Barracuda-URL: http://128.138.128.142:8000/cgi-bin/mark.cgi
Message-ID: <473A07E4.3050004@colorado.edu>
Date: Tue, 13 Nov 2007 13:24:04 -0700
From: Eric Schoeller <eric.schoeller@colorado.edu>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: Enabling Magic SysRq Key on boot before INIT
Subject: Enabling Magic SysRq Key on boot before INIT
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: omr-raz-2-pub.colorado.edu[128.138.123.155]
X-Barracuda-Start-Time: 1194985533
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at Colorado.EDU
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=8.0 tests=
X-Barracuda-Spam-Report: Code version 3.1, rules version 3.1.33804
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I would like to enable the Magic SysRq key immediately when the linux
kernel starts to boot, not when INIT begins. So, I am familiar with the
sysctl command and /etc/sysctl.conf - but I'd like to modify these types
of kernel variables earlier in the boot process. I thought that I could,
perhaps, pass an argument to my "kernel" line in my bootloader (grub)
configuration, but I have not been able to figure that out.

Is this possible?

Thanks,

Eric Schoeller
Infrastructure Systems and Services
University of Colorado, Boulder

