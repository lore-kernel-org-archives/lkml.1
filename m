Return-Path: <linux-kernel-owner+w=401wt.eu-S934068AbXCTUaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068AbXCTUaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934075AbXCTUaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:30:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:30862 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068AbXCTUap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:30:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=pjKUyH16Sp+tx/hvYxZzGbdEjmz35CQuP1JBB2uc7Agk9bANV+j4cnv8oloCGazbCxFEK6ekxSxGXyY8DFYG8BFuOn0vTxOkLoY8g7frAfXgVSkTRAHJ76p5YbIrkTHNh1UgBUwtnhrpmbjron5KT2jQifl7MzT2lLV4kFH7Tl8=
Message-ID: <460044A1.8070203@gmail.com>
Date: Tue, 20 Mar 2007 21:31:29 +0100
From: Ronald <ronald645@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Question Regarding The Radeon Framebuffer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm quite new to the lists, so I hope I placed my question correctly...

I want to know if my Ati Radeon X700 Pro (REV410) is supported with the 
current radeonfb framebuffer driver. I recompiled the kernel a lot, but 
with no succes...

lspci -v

01:00.1 Display controller: ATI Technologies Inc RV410 [Radeon X700 Pro 
(PCIE)] Secondary
       Subsystem: PC Partner Limited Unknown device 0621
       Flags: fast devsel
       Memory at d1010000 (64-bit, non-prefetchable) [disabled] [size=64K]
       Capabilities: [50] Power Management version 2
       Capabilities: [58] Express Endpoint IRQ 0

01:00.0 VGA compatible controller: ATI Technologies Inc RV410 [Radeon 
X700 Pro (PCIE)] (prog-if 00 [VGA])
       Subsystem: PC Partner Limited Unknown device 0620
       Flags: bus master, fast devsel, latency 0, IRQ 16
       Memory at c0000000 (64-bit, prefetchable) [size=256M]
       Memory at d1000000 (64-bit, non-prefetchable) [size=64K]
       I/O ports at a000 [size=256]
       Expansion ROM at d0000000 [disabled] [size=128K]
       Capabilities: [50] Power Management version 2
       Capabilities: [58] Express Endpoint IRQ 0
       Capabilities: [80] Message Signalled Interrupts: 64bit+ Queue=0/0 
Enable-
       Capabilities: [100] Advanced Error Reporting

                                               Thanks in advance
