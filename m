Return-Path: <linux-kernel-owner+w=401wt.eu-S934189AbXC0TNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189AbXC0TNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934191AbXC0TNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:13:31 -0400
Received: from Mail.MNSU.EDU ([134.29.1.12]:48878 "EHLO mail.mnsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934189AbXC0TNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:13:31 -0400
Message-ID: <46096CD7.1010100@mnsu.edu>
Date: Tue, 27 Mar 2007 14:13:27 -0500
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Oliver Joa <oliver@j-o-a.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
References: <46094344.4090007@j-o-a.de>
In-Reply-To: <46094344.4090007@j-o-a.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Joa wrote:
>
> I also often get a sata-bus-reset with the kernels 2.6.19.2
> and 2.6.20.2.
>
> What can I do to find the problem? I think about to change
> from xfs to ext2 but the filesystemcheck every 30 mounts lasts
> a long time.
>
> Do you have any Idea?
>

In this whole message I can only help on this point.  Switching to ext2 
will not help.  You've got *something* wrong with YOUR setup.  I have 
used the kernels you mention in VERY large environments with excellent 
and stable results.

You need to find out what's up with the sata-bus-reset problem.  It 
won't do *me* any good but people who can fix your problem will want the 
entire .config and dmesg to even guess about what is going on with 
*your* situation.

For more info on XFS.  This is a pretty nice FAQ:
http://oss.sgi.com/projects/xfs/faq.html

-- 
Jeffrey Hundstad
