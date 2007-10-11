Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbXJKRCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbXJKRCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 13:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbXJKRCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 13:02:25 -0400
Received: from client062.sevenl.net ([66.241.137.62]:4806 "EHLO pcburn.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbXJKRCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 13:02:24 -0400
Message-ID: <470E5714.4040303@pcburn.com>
Date: Thu, 11 Oct 2007 13:02:12 -0400
From: Chris Bergeron <chris@pcburn.com>
Reply-To: chris@pcburn.com
Organization: PCBurn Media
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Chris Bergeron <chris@pcburn.com>, linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
References: <4706AD19.4040605@pcburn.com> <20071010095432.GC30345@pazke.donpac.ru>
In-Reply-To: <20071010095432.GC30345@pazke.donpac.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Panin wrote:
> On 278, 10 05, 2007 at 05:31:05PM -0400, Chris Bergeron wrote:
>   
>> Hello all,
>>
>> I've just installed a multiport serial card released by an outfit called 
>> Syba.  This is an 8 port serial-only card with an Octopus style breakout 
>> cable.  The main chipset on it is an ITE IT8871F.
>>     
>
> Are you sure ? IIRC IT887x are PCI-ISA bridges with additional periphery
> and your lspci shows PLX chip. Can you send complete lspci -vv output ?
> Output of dmesg could be useful too.
>
>
>   
I'm sure that's what it says on the largest chip on the PCI card.  It 
could be that the other two chips are more relevant... the numbers from 
them are included below.

I've posted up a quick text only page with the diagnostic information 
from the system (full dmesg, lspci, etc) plus links to pictures of the 
board (since others might see something important that I'm not aware 
of).  You can access that at 
http://pcburn.com/files/Syba_serial_controller/index.html

One chip has "ITE IT8871F 0641-AYS ZF1M04L" written on it, and the other 
two have  a stylized celtic knot looking "T" followed by "TG16C554CJG 
FTA6M-001 0620-B".
