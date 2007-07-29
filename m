Return-Path: <linux-kernel-owner+w=401wt.eu-S965689AbXG2Wvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965689AbXG2Wvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965250AbXG2Wvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:51:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38441 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965235AbXG2Wvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:51:38 -0400
Message-ID: <46AD19F7.7040905@garzik.org>
Date: Sun, 29 Jul 2007 18:51:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.23-rc1
References: <1185720592.3434.7.camel@localhost.localdomain>
In-Reply-To: <1185720592.3434.7.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> This is basically a set of bug fixes with a few minor cleanups thrown
> in.  There are also a few bsg fixes we're taking through this tree
> because SCSI is the current sole consumer. The reason for the huge size
> is the lindent of the advansys driver along with a few cleanups.
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git


You missed
[SCSI] arcmsr: Fix hardware wait loops

	Jeff


