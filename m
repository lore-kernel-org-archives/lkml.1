Return-Path: <linux-kernel-owner+w=401wt.eu-S637757AbXDSM7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637757AbXDSM7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 08:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637759AbXDSM7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 08:59:09 -0400
Received: from smtpauth04.prod.mesa1.secureserver.net ([64.202.165.95]:58323
	"HELO smtpauth04.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S637757AbXDSM7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 08:59:08 -0400
Message-ID: <46276799.3080200@seclark.us>
Date: Thu, 19 Apr 2007 08:59:05 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>,
       7eggert@gmx.de, Chuck Ebbert <cebbert@redhat.com>,
       emisca <emisca.ml@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <88SeR-5Sf-15@gated-at.bofh.it> <88Sov-662-3@gated-at.bofh.it> <88SHV-6uL-29@gated-at.bofh.it> <8agVk-3wc-81@gated-at.bofh.it> <8b3IR-4mE-25@gated-at.bofh.it> <8b3SA-4z3-5@gated-at.bofh.it> <8b42g-51N-15@gated-at.bofh.it> <8bbdm-7iS-27@gated-at.bofh.it> <E1He8dA-0000mw-LI@be1.lrz> <46260981.1040109@gmail.com> <20070418132904.3322ba5f@the-village.bc.nu> <46261337.3010406@gmail.com> <20070418140346.636879a1@the-village.bc.nu> <46261F92.2080607@seclark.us> <Pine.LNX.4.61.0704190915320.30549@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704190915320.30549@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:

>On Apr 18 2007 09:39, Stephen Clark wrote:
>  
>
>>So this is the pop I hear on my new laptop that is using
>>libata=combined_mode when I shut my system down. I didn't get the
>>pop with the same disk drive in an older laptop that was only ide.
>>It sounds like a relay closing or opening, but is really my drive
>>head doing an emergency retract/park?
>>    
>>
>
>Most(?) disks' heads are spring-/power-based so that whenever
>they lose power, the spring retracts the head back to the park zone.
>
>Whether it is the disk head or something else.. take out the disk,
>and retry. Might not be that easy with laptops, though.
>
>
>Jan
>  
>
It is definitely the disk drive. It is located in the right front corner 
of my laptop so I put my ear
by it during shutdown and that is where the click is coming from. As I 
said before I had this same
drive in another laptop that was strictly ide so it used the older ide 
driver and it never did this.

Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



