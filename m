Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976Ab0CMUYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 15:24:37 -0500
Received: from smtp.infotech.no ([82.134.31.41]:49551 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932971Ab0CMUYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 15:24:35 -0500
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Mar 2010 15:24:35 EST
Message-ID: <4B9BF2B8.5090004@interlog.com>
Date: Sat, 13 Mar 2010 15:16:56 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] final scsi updates for 2.6.34-rc1
References: <1268242604.22601.25.camel@mulgrave.site> <alpine.LFD.2.00.1003121008420.3719@i5.linux-foundation.org> 	<1268418441.2802.61.camel@mulgrave.site> <2c0942db1003131135m1bea386dx4dd7990832cfbfea@mail.gmail.com>
In-Reply-To: <2c0942db1003131135m1bea386dx4dd7990832cfbfea@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On Fri, Mar 12, 2010 at 10:27 AM, James Bottomley wrote:
>> I do always have a tree ready in the first days of the merge window.  It
>> was, in fact, here:
> 
> [...]
> 
>> The slight problem is that I accumulate updates (like almost everyone
>> else) from the few days before the merge window opened up until about
>> the middle of the second week.  That's what goes into the final pull,
>> plus assorted bug fixes that showed up during the window.
> 
> You appear to being using git as a sort of baroque CVS. Fixes that
> arrive after the beginning of the merge window should be put into a
> separate branch other than the one ready for submission. Features that
> arrive after the beginning of the merge window should be placed into
> yet another branch destined for the next merge window.

Ray,
I'm sure that James will appreciate your insightful
advice. And Alan Cox is probably waiting for your
thoughts on the design of serial device drivers.

Amazing that after yet another Linus rant, people
crawl out of the woodwork to attack the victim.

Doug Gilbert


