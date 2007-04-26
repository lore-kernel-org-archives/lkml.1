Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbXDZTna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbXDZTna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbXDZTna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:43:30 -0400
Received: from smtpout06-04.prod.mesa1.secureserver.net ([64.202.165.227]:53911
	"HELO smtpout06.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754964AbXDZTn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:43:29 -0400
Message-ID: <463100DE.60201@seclark.us>
Date: Thu, 26 Apr 2007 15:43:26 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <4630E00B.3090502@tmr.com> <4630E9C8.5060000@garzik.org> <20070426183602.GT3468@stusta.de> <20070426185851.GA7352@electric-eye.fr.zoreil.com> <4630F9CB.10600@garzik.org>
In-Reply-To: <4630F9CB.10600@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

>Francois Romieu wrote:
>  
>
>>Pointer for the rtl8139 regression please ?
>>    
>>
>
>I'm guessing it's this one:
>
>  
>
>>	Subject    : boot failure: rtl8139: exception in interrupt routine
>>	References : http://lkml.org/lkml/2007/3/31/160
>>	Submitter  : Stephen Clark <Stephen.Clark@seclark.us>
>>	Status     : unknown
>>    
>>
>
>
>The poster says rtl8139, but doesn't provide more info.  His lspci says 
>"RTL8169SC", which sounds more like r8169 to me.
>
>	Jeff
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>
Yeah, that was my bad it is a RTL8169SC, and the 
problem was intermittent
sometimes is cause a panic othertimes it didn't.

It is laptop that does not have a serial port and 
I could not couldn't
get  the
kernel to boot using a usb serial port so I 
couldn't get a screen capture of
the intermittant panic.

Steve

-- 

"They that give up essential liberty to obtain 
temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government 
grows, liberty
decreases."  (Thomas Jefferson)




