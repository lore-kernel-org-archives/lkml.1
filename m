Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbYAGAJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbYAGAJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 19:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYAGAJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 19:09:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754740AbYAGAJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 19:09:03 -0500
Date: Sun, 6 Jan 2008 16:08:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <478169AD.3020808@rtr.ca>
Message-ID: <alpine.LFD.1.00.0801061605240.3148@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <478169AD.3020808@rtr.ca>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 6 Jan 2008, Mark Lord wrote:
> 
> We're still missing the sata_qstor regression fix from Tejun,
> and the patch from Venkatesh Pallipadi that reinstates max_cstate
> in sysfs for !CPU_IDLE.

I'm not seeing those in my inbox. I don't go out trolling for patches, 
because I expect that if the author of the patch really wants me to apply 
it, he'd send it upstream.

But I know a number of people are on vacation, and I suspect some of these 
fixes are just queued up, waiting for that.  E.g. I think Jeff is supposed 
to be back this week, etc..

			Linus
