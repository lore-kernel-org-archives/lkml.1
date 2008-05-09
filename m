Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbYEIPA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbYEIPA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYEIPAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:00:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39904 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbYEIPAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:00:43 -0400
Message-ID: <4824670A.4000608@garzik.org>
Date: Fri, 09 May 2008 11:00:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080430135405.ddc42075.akpm@linux-foundation.org> <Pine.LNX.4.64.0805091126000.30585@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0805091126000.30585@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 30 Apr 2008, Andrew Morton wrote:
> 
>> I get the impression that we're seeing very little non-Stephen testing 
>> of linux-next at this stage.  I hope we can ramp that up a bit, 
>> initially by having core developers doing at least some basic sanity 
>> testing.

I try to test linux-next on a few SATA test boxes, but it's definitely 
not a daily thing.


> Probably it would make sense also for distro vendors to make linux-next 
> snapshosts available in their development distro branches (redhat's 
> rawhide, opensuse's factory, etc), to make it easier to test by those 
> users who are willing to test if it works in their environment, but don't 
> want to compile kernels themselves.

Agreed...  any lead time on linux-next testing would be great.

	Jeff



