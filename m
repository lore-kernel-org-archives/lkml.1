Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbXJAOXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbXJAOXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXJAOXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:23:11 -0400
Received: from mail.tmr.com ([64.65.253.246]:36035 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbXJAOXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:23:10 -0400
Message-ID: <4701040E.1050604@tmr.com>
Date: Mon, 01 Oct 2007 10:28:30 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Patches for tiny 386 kernels, again. Linux kernel   2.6.22.7
References: <46F77A85.6020202@nerdgrounds.com> <20070924104940.50a52cf3.randy.dunlap@oracle.com> <46FD7104.9070609@tmr.com> <20071001134405.GA16330@csclub.uwaterloo.ca>
In-Reply-To: <20071001134405.GA16330@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Fri, Sep 28, 2007 at 05:24:20PM -0400, Bill Davidsen wrote:
>   
>> I'll offer this suggestion, knowing it may piss you off, given the 
>> difficulty of preserving whitespace on *many* mailers without using 
>> attachments, and given that attachments can be saved easily without 
>> prying them out of the message, why don't you (one person) switch to a 
>> capable mail agent, if only for patches, instead of trying to teach many 
>> people to jump through hoops to avoid whitespace issues?
>>
>> Not criticizing, just seems easier for everybody for you to avoid 
>> teaching people things they don't find useful elsewhere, or getting 
>> discouraged and not bothering.
>>     
>
> Ehm, so you want people to save the patch, then when replying they
> should load the patch into their (much better) mail client where they
> can comment on the patch?  That is the reason the patch should be
> inline.  People need to comment on it just as they would comment on any
> other plain text email.
>   

And in a perfect world everyone would have a mail client which made that 
easy, no one would be force by company policy or other circumstances to 
use a client which didn't work the way you think it should, no company 
or ISP would filter and mangle outgoing mail, and all vendors would 
understand that pristine patches are more important that all that stuff 
they do to make business communications look reasonable.

In my world people send me attachments so they don't get mangled, and if 
I need to quote them I know how to do so.
> Well that and some people use git to import patches from the email in a
> mostly automated way which also expects them to have the info at top
> with signed-off and then the patch, which attachments also screw up.
>
> So yes there are good reasons for getting a non broken mail client when
> sending patches to lkml.
>   

And reading them, many show attached text at the end of the message and 
make turning it into inline text simple.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

