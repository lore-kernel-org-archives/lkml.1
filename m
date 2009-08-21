Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbZHUVrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbZHUVrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932975AbZHUVrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:47:01 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:51383 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbZHUVq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:46:56 -0400
Date: Fri, 21 Aug 2009 23:46:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paul Walmsley <paul@pwsan.com>,
       Russell King <linux@arm.linux.org.uk>, vince@kyllikki.org,
       linux-kernel@vger.kernel.org, linux-arm@vger.kernel.org,
       torvalds@linux-foundation.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Mailing lists have moved
Message-ID: <20090821214656.GC16210@merkur.ravnborg.org>
References: <1250855566.3311.100.camel@macbook.infradead.org> <alpine.DEB.2.00.0908210925400.24646@utopia.booyaka.com> <1250868957.3311.110.camel@macbook.infradead.org> <4A8EBFFD.5000307@billgatliff.com> <1250870971.3311.173.camel@macbook.infradead.org> <4A8EC75D.6010203@billgatliff.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8EC75D.6010203@billgatliff.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 11:12:13AM -0500, Bill Gatliff wrote:
> David Woodhouse wrote:
>> On Fri, 2009-08-21 at 10:40 -0500, Bill Gatliff wrote:
>>   
>>> Ok, so which of the new lists should former linux-arm-kernel 
>>> subscribers be subscribed to?  I'm confused, I've seen mention of 
>>> four different lists now: three at infraded, and one at vger.  :)
>>>     
>>
>> Nothing has changed. There were always three lists: linux-arm (for
>> userspace stuff), linux-arm-toolchain and linux-arm-kernel.
>>
>> If you were subscribed to linux-arm-kernel before, then you are already
>> subscribed to linux-arm-kernel now. The list has just moved, that's all.
>>   
>
> Ok.  So help me understand what is the vger list for?  :)

davem created that list as a response to some discussions about the moderation
on the (now former) arm-kernel list.
It never took of mainly because Russell wanted to keep the lists on
the ARM machine he had to do some stability testing.

Then the vger folks did some misconfiguration that made it
defunct for a long time.

[I'm susprised why we did not just add a arm-toolchain@vger + arm-userspace@vger
and be done with it. The mail admins cope with a lost of lists and thye would
barely notice a few more]

	Sam
