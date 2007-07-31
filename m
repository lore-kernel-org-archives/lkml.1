Return-Path: <linux-kernel-owner+w=401wt.eu-S940354AbXGaBPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940354AbXGaBPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937347AbXGaBPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:15:07 -0400
Received: from [202.78.101.198] ([202.78.101.198]:55165 "EHLO mx1.hq.astra.ph"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S937524AbXGaBPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:15:05 -0400
Message-ID: <46AE8D25.20602@gmail.com>
Date: Tue, 31 Jul 2007 09:15:17 +0800
From: Carlo Florendo <subscribermail@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: ck@vds.kolivas.org, Satyam Sharma <satyam@infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       lkml@metanurb.dk
Subject: Re: [ck] Re: Linus 2.6.23-rc1
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707292023.36555.Martin@lichtvoll.de> <alpine.LFD.0.999.0707300008230.30928@enigma.security.iitk.ac.in> (sfid-20070729_204823_774350_03921303) <200707292118.45484.Martin@lichtvoll.de>
In-Reply-To: <200707292118.45484.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> The current kernel development process tries to pretend that there is no 
> human involvement. Which is plain inaccurate: It is *all* human 
> involvement, without a human not a single bit of kernel code would 
> change.

IMHO, the above statements are all plain conjectures. How could you assert 
that the kernel development process is without human development?

If you've followed the list for a while, you'd realize that the list is 
very human.  The fact that flames fly and abound, and the fact that 
individual persons tend to be very strong with respect to their opinions 
indicate that there is a rather high level of human dealings that happen on 
the list.

And I think you are digressing from the main issue, which is the empirical 
comparison of SD vs. CFS and to determine which is best.   The root of all 
the scheduler fuss was the emotional reaction of SD's author on why his 
scheduler began to be compared with CFS.

We obviously all saw how the particular authors tried to address the 
issues.  Ingo tried to address all concerns while Con simply ranted about 
his scheduler being better.  If this is what you think about being a bit 
more human, then I think that this has no place in the lkml.

We've all heard the "show me the numbers" argument, and as far as I can 
see, CFS now fairs much better than SD.

That's the issue.  The best one will emerge to be at the top.  From several 
months of tests and improvements, it seems CFS is emerging to be the better 
scheduler.

Best Regards,

Carlo

-- 
Carlo Florendo
Softare Engineer/Network Co-Administrator
Astra Philippines Inc.
UP-Ayala Technopark, Diliman 1101, Quezon City
Philippines
http://www.astra.ph

--
The Astra Group of Companies
5-3-11 Sekido, Tama City
Tokyo 206-0011, Japan
http://www.astra.co.jp
