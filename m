Return-Path: <linux-kernel-owner+w=401wt.eu-S1161165AbXBOUWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161165AbXBOUWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161166AbXBOUWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:22:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161165AbXBOUWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:22:02 -0500
Message-ID: <45D4C0E3.30600@redhat.com>
Date: Thu, 15 Feb 2007 15:21:55 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: v j <vj.linux@gmail.com>
CC: Trent Waddington <trent.waddington@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>	 <3d57814d0702142147p4eede234ybc9880a38772f55f@mail.gmail.com>	 <9b3a62ab0702142214p5c33a02am7e783c59ae0a64f1@mail.gmail.com>	 <3d57814d0702142235i687f8481x4eb72269e7f7fa9b@mail.gmail.com> <9b3a62ab0702142246r7e4eac4bv26c2ed46ff588871@mail.gmail.com>
In-Reply-To: <9b3a62ab0702142246r7e4eac4bv26c2ed46ff588871@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v j wrote:
> You don't get it do you. Our source code is meaningless to the Open
> Source community at large. It is only useful to our tiny set of
> competitors that have nothing to do with Linux. The Embedded space is
> very specific. We are only _using_ Linux. Just as we could have used
> VxWorks or OSE. Using our source code would not benefit anybody but
> our competitors. Sure we could make our drivers open-source. This is a
> decision that is made FIRST when evaluating an OS. If we we were
> required to make our drivers/HW open, we would just not have chosen
> Linux. It is as simple as that.

Collaborating with the competition ("coopetition") on a common 
technology platform reduces costs for anyone who chooses to get 
involved, giving them a collective competitive edge against anyone who 
doesn't.  This is why there is so much industry interest in F/OSS, and 
mortal enemies in the business world happily work together on technical 
issues in Linux.

If you choose to actively participate in the community, you will benefit 
from this phenomenon, as well as the patches you will receive from very 
smart kernel hackers who don't even own your hardware, and the pool of 
mature GPL code you can use to improve your drivers.

If you do not choose to actively participate in the community, you can 
still keep using existing versions of the kernel that work fine for you, 
even if future versions do not.  There are plenty of embedded devices 
out there using 2.4 or even 2.2 kernels that do what they need.

Your competitors who do participate in the community (and there are a 
lot in the embedded space) enjoy reduced development costs, more stable 
and better-reviewed code, continuous compatibility with the latest 
versions, and influence in the community over the direction of future 
development.  If you want to cede this advantage to your competitors, 
that's between you and your investors.

	-- Chris
