Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbYEWKfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbYEWKfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 06:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYEWKfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 06:35:41 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:54059 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756663AbYEWKfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 06:35:06 -0400
Message-ID: <48369DD7.8040907@superbug.co.uk>
Date: Fri, 23 May 2008 13:35:03 +0300
From: James Courtier-Dutton <James@superbug.co.uk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Natalie Protasevich <protasnb@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Bosko Radivojevic <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Number of bugs - statistics
References: <d6c8ef150805220528w6c4911bfq2be92eaa487a0f3@mail.gmail.com> <20080522144114.GC27301@cs181133002.pp.htv.fi> <20080522075135.4933161c@infradead.org> <20080522155425.GA2727@cs181133002.pp.htv.fi> <32209efe0805220920h1a2a0089t82b0173bbe239137@mail.gmail.com> <20080522165008.GB2727@cs181133002.pp.htv.fi>
In-Reply-To: <20080522165008.GB2727@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, May 22, 2008 at 09:20:46AM -0700, Natalie Protasevich wrote:
>   
>> On Thu, May 22, 2008 at 8:54 AM, Adrian Bunk <bunk@kernel.org> wrote:
>>     
>>> Andrew sees and handles the majority of incoming bug reports.
>>> Ask him whether he agress with this.
>>>
>>> And ALSA alone has 2000 open bug reports, which makes the open ACPI or
>>> SCSI bug numbers relatively irrelevant in any "number of bugs"
>>> statistics.
>>>
>>>       
> Not everyone uses Bugzilla (e.g. ALSA uses Mantis).
>
> And the majority of bug reports might still go only to mailing lists and 
> not into any bugtracker at all. As long as this happens the data is 
> simply not available.
>
>   
>> by various criteria: ALSA bugs
>> are numerous, which is not important for most enterprise server users
>> who would completely disregard this category, whereas desktop users
>> will probably concentrate on those more than any other.
>>     
>
>   
Although ALSA might have a lot of bug reports. Any bugs that affect 
kernel stability are fixed quickly.
The rest of the ALSA bugs are more along the lines of "This feature on 
this particular sound card variant does not seem to work". This 
generally implies un-implemented features that uses now want. Some times 
the fix is simply adding that variant to the quirks list and finding out 
which quirk should be applied.
So, once one removes the "un-implemented features" category from the 
ALSA bug list, one would expect the remaining number to be low.


