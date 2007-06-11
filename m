Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbXFKL0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbXFKL0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 07:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbXFKL00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 07:26:26 -0400
Received: from smtpgw02.netonehosting.com ([193.192.98.26]:59158 "EHLO
	smtpgw02.netonehosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbXFKL0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 07:26:25 -0400
Message-ID: <466D315A.4030403@netone.net.tr>
Date: Mon, 11 Jun 2007 14:26:18 +0300
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <20070609071231.GL2649@lug-owl.de> <466BB9B0.5030908@netone.net.tr> <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <466BCBBC.90305@netone.net.tr> <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm> <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com> <466C0901.4000405@netone.net.tr> <alpine.LFD.0.98.0706101025330.20321@woody.linux-foundation.org> <alpine.LFD.0.98.0706101029300.20321@woody.linux-foundation.org> <466D0A12.5030607@netone.net.tr> <20070611090348.GA18894@elte.hu>
In-Reply-To: <20070611090348.GA18894@elte.hu>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-NETONE-MailScanner-Information: Please contact the ISP for more information
X-NETONE-MailScanner: Found to be clean
X-NETONE-MailScanner-From: tarkan@netone.net.tr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tarkan Erimer <tarkan@netone.net.tr> wrote:
>
>   
>>> (*) And I've been pushing for that since before they even released 
>>> it - I walked out on Bill Joy at a private event where they 
>>> discussed their horrible previous Java license.
>>>       
>> Thanks for making things more clear :-) Some really strong indications 
>> that Sun is very willing to,at least, "Dual-License" the OpenSolaris 
>> with GPLv3. I think; in a very short time; we will see when the GPLv3 
>> finalized and released.
>>     
>
> that would certainly be a good and productive move from them. Note the 
> issue that others have pointed out to you: OpenSolaris is probably more 
> interested in picking up code from Linux than the other way around! :-) 
>   
Totally agreed :-)
> You mentioned "dtrace" and "ZFS". Firstly, Linux already has a "dtrace" 
> equivalent. Secondly, ZFS might be interesting in theory, although our 
> prior experience of having compatibly-licensed filesystems ported over 
> to Linux has been pretty negative: XFS ended up being an integration 
> nightmare - and that doesnt have to do anything with the qualities of 
> XFS (it's one of the cleanest Linux filesystems, if not the cleanest), 
> the problem is that components within a kernel are very tightly 
> integrated and rarely does it make sense to port over more than just 
> drivers or maybe libraries. And that's i guess what OpenSolaris lacks 
> and which i suspect it is mostly interested in: lots of nice Linux 
> drivers ;-) XFS, the largest Linux filesystem is 100K lines of code - 
> and ZFS (i've never seen it) is very likely smaller than that. Linux 
> drivers on the other hand, as of today, are _3.7 million_ lines of code 
> and enable Linux to run on 99% of the hardware that is produced today. 
> Guess which one has the larger strategic significance? ;-)
>
> 	Ingo
>   
Yep, it is clear that sun needs more things like drivers etc. to make 
OpenSolaris more usable and user friendly. Here is an article about this 
subject and some thoughts of Ian (Murdock) about it ;-)

http://www.zdnet.com.au/news/software/soa/Sun-hopes-for-Linux-like-Solaris/0,130061733,339276057,00.htm


