Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbXK1Wuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbXK1Wuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758793AbXK1Wun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:50:43 -0500
Received: from main.gmane.org ([80.91.229.2]:56268 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758174AbXK1Wum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:50:42 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: 2.6.24-rc3-git3: usb hardware interrupts using 25% of CPU time
Date: Wed, 28 Nov 2007 22:50:26 +0000 (UTC)
Message-ID: <pan.2007.11.28.22.50.25@telenet.be>
References: <pan.2007.11.28.22.33.18@telenet.be>
	<200711290002.01850.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: d54c1e7e8.access.telenet.be
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-usb-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 00:02:01 +0100, Rafael J. Wysocki wrote:

> On Wednesday, 28 of November 2007, Frederik Himpe wrote:
>> I installed Linux 2.6.24-rc3-git3 on a PPC based Apple Powerbook G4
>> system. Now with top I see that over 20% of CPU time is used by
>> hardware interrupts. Looking at /proc/interrupts, the number in the row
>> ohci_hcd:usb1 is rising very quickly:
> 
> What's the last kernel that worked correctly?

Actually I'm not sure: the kernel I was running before was Debian's 2.6.22 
kernel package

-- 
Frederik

