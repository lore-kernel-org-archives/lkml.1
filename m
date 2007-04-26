Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbXDZFpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbXDZFpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbXDZFpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:45:07 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:25442 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754731AbXDZFpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:45:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=MoU4DJ6Ikd/3XcXKvo14gHYralF3c26WIE65uMgNHhmXIFnG4VYjPmxMxQJB4WgUdY83icyWlPQB3p44glu5+SfbXEbGVY6KYuvHcRtwOb9FhDQSLVPpzh01q6N5xRTXNithvmRZoLghq8r/+48xY3AM9pNzkY1t6Uz66vft7Vg=  ;
X-YMail-OSG: wMQC4HAVM1lWAc74_WAshxuNRl1QKNd97r5OeYZ2Xkxs88EWtk695_P_FKd79jJ4mg5FlZuso04jrW3zlwvqgYVK1A0lA11oPxvcx_SxnVyHinyepME-
Message-ID: <46303C5A.3010409@yahoo.com.au>
Date: Thu, 26 Apr 2007 15:44:58 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426050253.GA18335@kroah.com>
In-Reply-To: <20070426050253.GA18335@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Apr 26, 2007 at 06:08:06AM +0200, Adrian Bunk wrote:
> 
>>What I will NOT do:
>>Waste my time with tracking 2.6.22-rc regressions.
> 
> 
> I sure hope you don't do this.
> 
> Tracking these is tough, and I think you are doing a great job with it.
> 
> No release will have no regressions, there's just too many different
> combinations of hardware and sometimes people don't have the time to
> test to see if their original report is even fixed or not.
> 
> And some of them will get fixed with patches coming in the next kernel
> release, which will then be tracked down and added to the -stable
> releases.
> 
> So if you can, please keep it up, if you think it's a thankless job,
> here's my hearty thanks for doing this work.  It's really needed and I
> really appreciate it.

Fifthed here, Adrian. It could potentially become one of the best things
to happen to the mainline release process (and I believe has already been
worthwhile). Even if it takes a while for people to get on board, or some
regressions slip through. And note, a release with regressions doesn't
make your hard work useless -- you've still got the important who, when,
how, etc. info that can be used in future, and it could serve as a "known
issues for upgraders" document as well.

-- 
SUSE Labs, Novell Inc.
