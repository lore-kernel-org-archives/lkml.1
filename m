Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbYJUTNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbYJUTNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYJUTNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:13:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54787 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbYJUTNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:13:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48FE2978.5070108@s5r6.in-berlin.de>
Date: Tue, 21 Oct 2008 21:11:52 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: felipe.balbi@nokia.com
CC: Greg KH <greg@kroah.com>, Willy Tarreau <w@1wt.eu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com> <20081017174657.GH2221@kroah.com> <20081017204723.15114eaa@lxorguk.ukuu.org.uk> <20081017214409.GB3585@kroah.com> <20081018084504.GQ24654@1wt.eu> <20081020203033.GB20788@kroah.com> <20081020205400.GB26744@gandalf.research.nokia.com> <20081020210648.GA30389@kroah.com> <20081020222434.GF26744@gandalf.research.nokia.com>
In-Reply-To: <20081020222434.GF26744@gandalf.research.nokia.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:
> On Mon, Oct 20, 2008 at 02:06:48PM -0700, Greg KH wrote:
>> On Mon, Oct 20, 2008 at 11:54:00PM +0300, Felipe Balbi wrote:
>>> when we move to 2.7, we know it'll be the start
>>> for the 2.8 kernel series.
>> Um, did you not get the memo 3 years ago saying we are changing our
>> development model and there will not be a 2.7 development series?
>>
>> Damm, I thought I had printed it out and placed it on everyone's chairs.
>> Those pesky cleaners must have picked it up and recycled it, sorry about
>> that...
>>
>>> Just like the migration from 2.4 to 2.5.
>> Please don't bring up the dark ages again, many of us went through
>> things back then that have taken a lot of counseling to be able to get
>> over.
> 
> sorry if i'm developing linux kernel for as long as you are. It's really
> not my business how many hours of counseling you had to attend to get
> over a version numbering change.

The switch from 2.2/2.3/2.4/2.5 to 2.6.x was not a change of numbering 
scheme, it was a change of the development model.  2.4 and 2.5 were two 
parallel mainlines.  2.6.x is a single mainline, and there won't be two 
mainlines again in any foreseeable future.

> Maybe you still need a bit more, judging by your reply.

Or maybe not.  You obviously misread his post.
-- 
Stefan Richter
-=====-==--- =-=- =-=-=
http://arcgraph.de/sr/
