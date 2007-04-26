Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbXDZTxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbXDZTxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbXDZTxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:53:44 -0400
Received: from smtpout09-04.prod.mesa1.secureserver.net ([64.202.165.17]:48890
	"HELO smtpout09.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754982AbXDZTxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:53:43 -0400
Message-ID: <46310343.60005@seclark.us>
Date: Thu, 26 Apr 2007 15:53:39 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <4630E00B.3090502@tmr.com> <4630E9C8.5060000@garzik.org> <20070426183602.GT3468@stusta.de> <20070426185851.GA7352@electric-eye.fr.zoreil.com> <4630F9CB.10600@garzik.org> <20070426194356.GB7352@electric-eye.fr.zoreil.com>
In-Reply-To: <20070426194356.GB7352@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:

>Jeff Garzik <jeff@garzik.org> :
>  
>
>>Francois Romieu wrote:
>>    
>>
>>>Pointer for the rtl8139 regression please ?
>>>      
>>>
>>I'm guessing it's this one:
>>
>>    
>>
>>>	Subject    : boot failure: rtl8139: exception in interrupt routine
>>>	References : http://lkml.org/lkml/2007/3/31/160
>>>	Submitter  : Stephen Clark <Stephen.Clark@seclark.us>
>>>	Status     : unknown
>>>      
>>>
>>The poster says rtl8139, but doesn't provide more info.  His lspci says 
>>"RTL8169SC", which sounds more like r8169 to me.
>>    
>>
>
>Yes, thanks.
>
>The r8169 driver has been added a few bugfixes between 2.6.21-rc5 and now.
>Some are related to latent, timing changes induced bugs.
>
>Stephen, would you mind testing 2.6.21 and open a PR at bugzilla.kernel.org
>if the bug does not go away ?
>
>Bugzilla e-mails end directly in my mailbox. l-k traffic can be temporarily
>unnoticed (especially on saturday night).
>
>  
>
Sure I'll give it a try in the next couple of days.

Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



