Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbXELIHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbXELIHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 04:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbXELIHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 04:07:39 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:50756 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbXELIHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 04:07:37 -0400
Message-ID: <464575BF.1060105@simon.arlott.org.uk>
Date: Sat, 12 May 2007 09:07:27 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Finn Thain <fthain@telegraphics.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org, trival@kernel.org
Subject: Re: [PATCH] spelling fixes: arch/m68knommu/
References: <4644C716.1020000@simon.arlott.org.uk> <Pine.LNX.4.64.0705121024480.14127@loopy.telegraphics.com.au>
In-Reply-To: <Pine.LNX.4.64.0705121024480.14127@loopy.telegraphics.com.au>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/07 02:03, Finn Thain wrote:
> 
> On Fri, 11 May 2007, Simon Arlott wrote:
> 
>> - *	Local routines to interrcept the standard I/O and vector handling
>> - *	code. Don't include this 'till now - initialization code above needs
>> + *	Local routines to intercept the standard I/O and vector handling
>> + *	code. Don't include this until now - initialization code above needs
>>   *      access to the real code too.
> 
> What's wrong with 'til?
> 

Nothing, but is there anything wrong with correcting 'till to until?

>> - *	Sub-architcture dependant initialization code for the Freescale
>> + *	Sub-architcture dependent initialization code for the Freescale
> 
> ...
> 
>> - *	Sub-architcture dependant initialization code for the Freescale
>> + *	Sub-architcture dependent initialization code for the Freescale
> 
> ...
> 
>> - *	Sub-architcture dependant initialization code for the Motorola
>> + *	Sub-architcture dependent initialization code for the Motorola
> 
> You want "Sub-architecture".

Bah. I managed to miss that word in the line more than once... and I 
had it highlighted in red :|

-- 
Simon Arlott
