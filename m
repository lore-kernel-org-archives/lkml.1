Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbXIAOcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbXIAOcn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 10:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXIAOcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 10:32:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33446 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXIAOcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 10:32:35 -0400
Message-ID: <46D97801.5050104@garzik.org>
Date: Sat, 01 Sep 2007 10:32:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Karsten Keil <kkeil@suse.de>, Andi Kleen <ak@suse.de>
Subject: New stuff pushed to -mm
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just added three branches to 'ALL' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

dmi-const		DMI constification

pciseg			x86 PCI domain support, newly updated
			for the latest Muli stuff upstream

isdn-cleanups		Obvious and simple cleanups for ISDN

All are targetted for 2.6.24.  Just sent out dmi-const and pciseg to 
LKML.  Sent isdn-cleanups to LKML, ISDN list and Karsten a while ago.

The "super mondo ISDN cleanups", converting ISDN HiSax drivers to 
PCI/PNP/ISA APIs, are not included in this batch.

	Jeff


