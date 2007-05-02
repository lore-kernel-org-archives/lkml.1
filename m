Return-Path: <linux-kernel-owner+w=401wt.eu-S1766925AbXEBUKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766925AbXEBUKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766936AbXEBUKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:10:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766925AbXEBUKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:10:41 -0400
Message-ID: <4638EDCF.6030803@redhat.com>
Date: Wed, 02 May 2007 16:00:15 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [git pull] New firewire stack
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de>
In-Reply-To: <tkrat.087ee29add656926@s5r6.in-berlin.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Christoph Hellwig wrote:
..
>> Please send out patches for review first.
> 
> Yes, it's been a while since the last submission for review [1], and
> most of the changes went over linux1394-devel only.  And to put it
> mildly, there aren't a lot of capable reviewers watching that list.
...

> (If this division seems odd, don't blame Kristian, blame me. :-)
> I'm looking forward to comments.

Looks good to me, thanks Stefan.  The first three patches don't compile on 
their own as they are, but it's a good split of the core stack.

Kristian

