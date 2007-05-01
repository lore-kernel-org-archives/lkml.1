Return-Path: <linux-kernel-owner+w=401wt.eu-S1031676AbXEALzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031676AbXEALzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031679AbXEALzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:55:38 -0400
Received: from smtpauth02.prod.mesa1.secureserver.net ([64.202.165.182]:59874
	"HELO smtpauth02.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031676AbXEALzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:55:36 -0400
Message-ID: <46372AB6.7000902@seclark.us>
Date: Tue, 01 May 2007 07:55:34 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
References: <20070429161542.GA12501@havoc.gtf.org> <46364901.4000907@redhat.com> <46364C04.4050208@garzik.org> <46364FFA.9050500@seclark.us> <46365234.6010804@garzik.org>
In-Reply-To: <46365234.6010804@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

>Stephen Clark wrote:
>  
>
>>Yeah the kernel will boot but the hd performance is sh*t on my laptop. I 
>>am running FC6 with
>>kernel 2.6.21 and without the combined_mode setting my disk performance 
>>goes down to a
>>whopping 1.25mb/sec from 44mb/sec when I boot with combined_mode=libata. 
>>It make my
>>system unusable!
>>    
>>
>
>
>No, that's the split-driver configuration that causes the slowdown.
>
>Now that both drivers fully support the hardware, either driver can make 
>things go full speed.
>
>Please try testing the update first :)
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
Ok, I'am willing to test it out, but how to I get a patch file from the 
git stuff?

I currently have the 2.6.21 kernel source.

Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



