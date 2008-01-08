Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbYAHBTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbYAHBTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 20:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYAHBT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 20:19:28 -0500
Received: from simmts7.bellnexxia.net ([206.47.199.165]:50261 "EHLO
	simmts7-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbYAHBT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 20:19:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAABZegkecIpjJ/2dsb2JhbAAIqFE
Message-ID: <4782CF9C.6000508@gmail.com>
Date: Mon, 07 Jan 2008 21:19:24 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Top 10 kernel oopses for the week ending January 5th, 2008
References: <477FF149.4070609@linux.intel.com> <20080105213935.GN27894@ZenIV.linux.org.uk> <20080107174431.GC27741@fieldses.org>
In-Reply-To: <20080107174431.GC27741@fieldses.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Sat, Jan 05, 2008 at 09:39:35PM +0000, Al Viro wrote:
>> On Sat, Jan 05, 2008 at 01:06:17PM -0800, Arjan van de Ven wrote:
>>> The http://www.kerneloops.org website collects kernel oops and 
>>> warning reports from various mailing lists and bugzillas as well 
>>> as with a client users can install to auto-submit oopses. Below 
>>> is a top 10 list of the oopses collected in the last 7 days. 
>>> (Reports prior to 2.6.23 have been omitted in collecting the top 
>>> 10)
>>> 
>>> This week, a total of 49 oopses and warnings have been reported,
>>>  compared to 53 reports in the previous week.
>> FWIW, people moaning about the lack of entry-level kernel work 
>> would do well by decoding those to the level of "this place in this
>>  function, called from <here>, with so-and-so variable being
>> <this>" and posting the results.  As skills go, it's far more
>> useful than "how to trim the trailing whitespace" and the rest of 
>> checkpatch.pl-inspired crap that got so popular lately...
> 
> Is there any good basic documentation on this to point people at?
> 

I would second this question.  I see people "decode" oops on lkml often enough, but I've never been entirely sure how its done.  Is it somewhere in Documentation?

-- 
Kevin Winchester
