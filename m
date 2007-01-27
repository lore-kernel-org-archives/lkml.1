Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbXA0NWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbXA0NWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 08:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXA0NWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 08:22:19 -0500
Received: from weequay.is.scarlet.be ([193.74.71.24]:47078 "EHLO
	weequay.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXA0NWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 08:22:19 -0500
Message-ID: <45BB51F9.5070100@scarlet.be>
Date: Sat, 27 Jan 2007 13:22:01 +0000
From: Joel Soete <soete.joel@scarlet.be>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Joel Soete <soete.joel@scarlet.be>
CC: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@redhat.com>,
       Ioan Ionita <opslynx@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com> <20061116235048.3cd91beb@localhost.localdomain> <df47b87a0611161730p70e1dd41iad7d27a0bf9283ff@mail.gmail.com> <df47b87a0611161734h818fc4dneaad5eeaa7e3c392@mail.gmail.com> <20061117100559.GA10275@devserv.devel.redhat.com> <459286C2.7080705@scarlet.be> <45943C15.4010506@scarlet.be> <459B31AE.709@gmail.com> <459BE5AC.70703@scarlet.be>
In-Reply-To: <459BE5AC.70703@scarlet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC-scarlet.be-Metrics: weequay 20001; Body=7 Fuz1=7 Fuz2=7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I just tested libata with this newest 2.6.20-rc6 but no changes ;-(

Any news?

Thanks,
	Joel

Joel Soete wrote:
> Hello Tejun,
> 
> Tejun Heo wrote:
>> Joel Soete wrote:
>>> Hello Alan, Jeff,
>>>
>>> Reading a paper on this new libata, I just want to try but failled yet
>>> for what said this thread "ATAPI CDROM" ;_(.
>>>
>>> I first test the latest stable 2.6.19.1 without luck, so I also want to
>>> try latest 2.6.20-rc2 unfortunately without more success.
>>
>> I'm attaching two patches.  One against 2.6.19 the other against
>> 2.6.20-rc3.  Both have about the same effect.  Please apply and report
>> what happens and full dmesg.
>>
>> Thanks and happy new year.
>>
> Happy new year too ;-)
> 
> Because of lack of time I only test your patch against 2.6.20-rc3.
> 
> Unfortunately it doesn't help yet, sorry (i would very like to be of 
> more help).
> 
> I here attache the full dmesg of my i386 boxe.
> 
> Thanks again,
>     Joel
> 
> 
