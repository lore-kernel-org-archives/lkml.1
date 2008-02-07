Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbYBGPT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbYBGPT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbYBGPTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:19:19 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38377 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756423AbYBGPTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:19:18 -0500
Date: Thu, 7 Feb 2008 10:16:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: any cpu hotplug changes in 2.6.24-current-git?
Message-ID: <20080207091630.GA1816@elf.ucw.cz>
References: <20080206125807.GB26817@elf.ucw.cz> <47A9D14C.8000002@gmail.com> <20080206224441.GC1630@elf.ucw.cz> <47AA558F.7030006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AA558F.7030006@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-02-06 19:49:19, Gregory Haskins wrote:
> Pavel Machek wrote:
>> Hi!
>>
>>   
>>>> Are there any recent changes in cpu hotplug? I have suspend (random)
>>>> problems, nosmp seems to fix it, and last messages in the "it hangs"
>>>> case are from cpu hotplug...
>>>>       
>>
>>   
>>>   Can you send along your cpuinfo?
>>>     
>>
>> It happened on more than one machine, one cpuinfo is:
>>   
> Ah, ok.  This one is a C2D, correct?  The only reason I asked is that 

I don't know what "C2D" means... core2duo? Yes, this is core2duo.

> someone was reporting an s2ram problem on P4s on some of that root-domain 
> logic I submitted a little while ago (and was merged in .25), whereas C2D 
> seemed fine.  That doesn't mean anything here, really.  The problem could 
> still be my code, or it might be unrelated.  I was just wondering if you 
> also had a P4 on the troubled systems.
>
> So is your problem on suspend or resume?  (or both?)  (I know you mentioned 
> it was random problems, but I wasn't sure if you could qualify that 
> further)

It dies at suspend, always in same place, but not always.

OTOH last few suspends worked for me, not sure what changed...

> Any info you can provide will be appreciated. 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
