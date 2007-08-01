Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbXHACyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbXHACyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 22:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXHACye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 22:54:34 -0400
Received: from [202.78.101.198] ([202.78.101.198]:34062 "EHLO mx1.hq.astra.ph"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751008AbXHACyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 22:54:33 -0400
Message-ID: <46AFF5F5.2090100@gmail.com>
Date: Wed, 01 Aug 2007 10:54:45 +0800
From: Carlo Florendo <subscribermail@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, ck@vds.kolivas.org,
       Satyam Sharma <satyam@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: Linus 2.6.23-rc1
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707292023.36555.Martin@lichtvoll.de> <alpine.LFD.0.999.0707300008230.30928@enigma.security.iitk.ac.in> <200707292118.45484.Martin@lichtvoll.de> <46AE8D25.20602@gmail.com> <20070731095723.GH32582@gnuppy.monkey.org>
In-Reply-To: <20070731095723.GH32582@gnuppy.monkey.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Huey (hui) wrote:
> On Tue, Jul 31, 2007 at 09:15:17AM +0800, Carlo Florendo wrote:
>> And I think you are digressing from the main issue, which is the empirical 
>> comparison of SD vs. CFS and to determine which is best.   The root of all 
>> the scheduler fuss was the emotional reaction of SD's author on why his 
>> scheduler began to be compared with CFS.
> 
> Legitimate emotional reaction for being locked out of the development
> process. There's a very human aspect to this, yes, a negative human
> aspect that pervade Linux kernel development and is overly defensive and
> protective of new ideas.

Yes, the reaction was legitimate but it could have been better.  It would 
have benefited everyone if instead of posting rants, numbers and patches or 
suggested solutions were posted.  Up until today, some posters that 
complain on how CFS fairs worse than SD simply post reports that say:

"I use this system in this way and it does not fair well with cfs!"

Look at this one for example:

http://lkml.org/lkml/2007/7/31/199

It looks technical but it isn't.

The author simply stated that he built his own lightweight Linux box that 
specializes in audio but there has not been any technical characteristic of 
the problem.  We don't even know the audio libraries he's using but simply 
claimed that he wrote his own.

The report, if I were the one to debug it, is completely useless since it 
does not even give some reproducability hints nor technical characteristics 
of the system.

This is what some of the SD fan-boys do.  Rant.

Thank you very much.

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
