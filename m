Return-Path: <linux-kernel-owner+w=401wt.eu-S1422794AbXBPAKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422794AbXBPAKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422795AbXBPAKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:10:45 -0500
Received: from mailhub2.otago.ac.nz ([139.80.64.247]:39218 "EHLO
	mailhub2.otago.ac.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422794AbXBPAKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:10:44 -0500
Message-ID: <45D4F67D.4030902@maths.otago.ac.nz>
Date: Fri, 16 Feb 2007 13:10:37 +1300
From: Greg Trounson <gregt@maths.otago.ac.nz>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <20070215061149.GE15654@redhat.com> <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com> <20070215165339.GB5285@thunk.org>
In-Reply-To: <20070215165339.GB5285@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Wed, Feb 14, 2007 at 10:27:10PM -0800, v j wrote:
>> You are right. I have not contributed anything to Linux. Except one
>> small patch to the MTD code. However, I don't think that is the point
>> here. I am perfectly willing to live with the way Linux is today. I am
>> telling you as a user that if Linux continues on the current path it
>> will become less and less attractive to Embedded Users.
> 
> But so what?  How will that hurt *Linux*?  If the Embedded developers
> don't contribute changes back, it doesn't hurt us any if they go away
> and start paying $$$ to VxWorks instead of using Linux for free.  

I disagree.  Linux needs popularity at the moment.

Otherwise, Linux may be in for a hard time once manufacturers standardize on TPM-enabled 
processors that only allow 'authorized' code to run.  And it looks like this is going to 
happen.

Unless there is a sufficient user base (ie a market) for Linux, what incentive are Intel, 
AMD, etc going to have to make their hardware run anything except code signed by Microsoft?

When taken off modern CPUs, Linux will be relegated to hobby cpu fabs, legacy hardware and 
maybe a niche back in the embedded market.  Then watch development all but stagnate. 
Something I'd rather not see happen.

Greg

