Return-Path: <linux-kernel-owner+w=401wt.eu-S933615AbYB2VHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbYB2VHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbYB2VHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:07:45 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:57493 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537AbYB2VHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:07:45 -0500
Message-ID: <47C87460.2030705@davidnewall.com>
Date: Sat, 01 Mar 2008 07:38:48 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zan Lynx <zlynx@acm.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use	GPL-only	symbols
References: <1204236662.3612.6.camel@dv>	 <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>	 <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>	 <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>	 <1204304352.6767.21.camel@localhost>	 <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>	 <1204305609.21719.16.camel@dv>	 <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>	 <1204313978.2316.8.camel@dv> <20080229201711.GF3234@tuxdriver.com>	 <47C86DCA.5080706@davidnewall.com> <1204318797.2316.29.camel@dv>
In-Reply-To: <1204318797.2316.29.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Roskin wrote:
> On Sat, 2008-03-01 at 07:10 +1030, David Newall wrote:
>   
>> John W. Linville wrote:
>>     
>>> On Fri, Feb 29, 2008 at 02:39:38PM -0500, Pavel Roskin wrote:
>>>   
>>>       
>>>> I doubt ndiswrapper will ever be ported to the
>>>> userspace.  It's much more likely that some other approach will be used.
>>>>     
>>>>         
>>> Maybe it should be -- that might solve a lot of problems
>>>       
>> Maybe it's time to rename it from "ndiswrapper" to "NdisWrapper".
>>
>> How stupid do you have to be to not see that it will be fixed in any way
>> necessary.
>>     
>
> I'm quite sure that something like that is going to be the short term
> fix.  Still, it would be nice to have a more long term solution, the one
> that tries to resolve the tensions rather than hide them.  I'm not sure
> it's possible, but just trying to negotiate could help find
> understanding

I think there's a political agenda, and that's something that nobody can
solve.  The simplest solution is to change the name it uses on a regular
basis, and that something relatively  unimportant.  People will still
call it ndiswrapper, but it will identify itself to the kernel as
wrappythingy, and then ndisthingy, and then wrapndis.  Heck, make it
purely random.  Solve the problem for all time.

It's a stupid problem promulgated by stupid people, and I use the word
"stupid" in it's most pejorative sense.
