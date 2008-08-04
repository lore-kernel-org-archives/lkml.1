Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYHDBaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYHDBaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 21:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYHDB34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 21:29:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:35015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbYHDB3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 21:29:55 -0400
From: "NeilBrown" <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>, "Neil Brown" <neilb@suse.de>,
       "Michael Shuey" <shuey@purdue.edu>,
       "Shehjar Tikoo" <shehjart@cse.unsw.edu.au>,
       linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       rees@citi.umich.edu, aglo@citi.umich.edu
Date: Mon, 4 Aug 2008 11:29:45 +1000 (EST)
Message-ID: <52873.192.168.1.70.1217813385.squirrel@neil.brown.name>
In-Reply-To: <20080804003206.GB6119@disturbed>
References: <200807241311.31457.shuey@purdue.edu>
    <20080730192110.GA17061@fieldses.org>
    <4890DFC7.3020309@cse.unsw.edu.au>
    <200807302235.50068.shuey@purdue.edu>
    <20080731031512.GA26203@fieldses.org>
    <18577.25513.494821.481623@notabene.brown>
    <20080801072320.GE6201@disturbed> <20080801191559.GI7764@fieldses.org>
    <20080804003206.GB6119@disturbed>
Subject: Re: high latency NFS
Cc: "Greg Banks" <gnb@melbourne.sgi.com>
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, August 4, 2008 10:32 am, Dave Chinner wrote:
> On Fri, Aug 01, 2008 at 03:15:59PM -0400, J. Bruce Fields wrote:
>> On Fri, Aug 01, 2008 at 05:23:20PM +1000, Dave Chinner wrote:

>> > i.e. take the solution that Greg banks used for the CPU scheduler
>> > overload issue (limiting the number of nfsds woken but not yet on
>> > the CPU),
>>
>> I don't remember that, or wasn't watching when it happened.... Do you
>> have a pointer?
>
> Ah, I thought that had been sent to mainline because it was
> mentioned in his LCA talk at the start of the year. Slides
> 65-67 here:
>
> http://mirror.linux.org.au/pub/linux.conf.au/2007/video/talks/41.pdf

Ahh... I remembered Greg talking about that, went looking, and
couldn't find it.  I couldn't even find any mail about it, yet I'm
sure I saw a patch..

Greg: Do you remember what happened to this?  Did I reject it for some
reason, or did it never get sent?  or ...

NeilBrown

