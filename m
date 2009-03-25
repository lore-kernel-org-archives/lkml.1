Return-Path: <linux-kernel-owner+w=401wt.eu-S1763696AbZCYSlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763696AbZCYSlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761560AbZCYSlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:41:31 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:48928 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760331AbZCYSla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:41:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=qy5Xbqy3uOwgI7xG2a9Kn6BtI8blOwPct9rrvyu4Y7lKEZJOmIXWPy22oa8Msfii;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <49CA7AAB.1040506@earthlink.net>
Date: Wed, 25 Mar 2009 14:40:43 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>	<49C87B87.4020108@krogh.cc>	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>	<20090324093245.GA22483@elte.hu>	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>	<20090324103111.GA26691@elte.hu>	<20090324132032.GK5814@mit.edu>	<20090324160353.06a4a5ed@hobbes.virtuouswap> <20090324170559.1667c847@infradead.org>
In-Reply-To: <20090324170559.1667c847@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec7960b815c82ed0eacceadc4f3a599f1589350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.118.36.246
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 24 Mar 2009 16:03:53 -0700
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
>> I remember early in the 2.6.x days there was a lot of focus on making
>> interactive performance good, and for a long time it was.  But this
>> I/O problem has been around for a *long* time now... What happened?
>> Do not many people run into this daily?  Do all the filesystem
>> hackers run with special mount options to mitigate the problem?
>>
> 
> the people that care use my kernel patch on ext3 ;-)
> (or the userland equivalent tweak in /etc/rc.local)
> 
> 
> 
Ok, I bite what is the userland tweak?

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


