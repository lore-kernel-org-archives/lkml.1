Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbXLCQ6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbXLCQ6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbXLCQ63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:58:29 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:58705 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbXLCQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:58:28 -0500
Date: Mon, 3 Dec 2007 11:58:07 -0500
Message-Id: <200712031658.lB3Gw7ds018649@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: overdue items in feature-removal-schedule
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, Andrew, Christoph,

There are 29 listed items in feature-removal-schedule.txt.  11 of those have
dates or kernel versions that have passed, including this one:

What:	remove EXPORT_SYMBOL(kernel_thread)
When:	August 2006

One feature (removal of sys_sysctl) is listed for September 2010: are we
really able to predict the future with this much accuracy?

When, if at all, will those future/overdue features be removed for real?
Have any of them been removed already?  It's very important to developers to
have more accurate removal schedule for planning purposes.

I think setting dates on feature removal isn't compatible with the current
model of kernel code development, b/c despite our best efforts, it's hard to
predict the precise release of the next 2.6.(x+1) kernel.  I think it's
better to change all of those dates to future kernel versions (a couple of
items do so).  When those dates were assigned, was there a specific kernel
version in mind?

Thanks,
Erez.
