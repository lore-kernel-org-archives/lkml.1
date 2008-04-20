Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbYDTWUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbYDTWUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 18:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYDTWUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 18:20:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50422 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYDTWUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 18:20:09 -0400
Message-ID: <480BC191.6030905@garzik.org>
Date: Sun, 20 Apr 2008 18:20:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [for 2.6.26] ISDN cleanups, ok for upstream?
References: <20080418225355.GA30189@havoc.gtf.org> <20080418164113.6863213d.akpm@linux-foundation.org>
In-Reply-To: <20080418164113.6863213d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 18 Apr 2008 18:53:55 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> I don't know the current state of
>> akpm's pull of jgarzik/misc-2.6.git#ALL.
> 
> oops.  It seems that I disabled it quite a long time ago.   I'll resurrect
> it.

Thanks!  Though note that it will be temporary empty, after 
isdn-cleanups is sent upstream.

If it's not too much trouble, I would appreciate you continuing to poll 
misc-2.6.git#ALL, even if it comes up empty.  That tree (and branch) 
acts as an outlet for miscellaneous jgarzik stuff that may go upstream 
"vaguely soonish maybe"  :)


>> The 'isdn-cleanups' branch of
>> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git isdn-cleanups
> 
> That merges cleanly against the small number of isdn patches which are
> pending in -mm, so we're OK from that POV.

Thanks for checking.

Regards,

	Jeff


