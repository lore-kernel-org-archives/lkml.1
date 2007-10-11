Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbXJKUtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbXJKUtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 16:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbXJKUtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 16:49:10 -0400
Received: from client062.sevenl.net ([66.241.137.62]:1389 "EHLO pcburn.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbXJKUtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 16:49:09 -0400
Message-ID: <470E8C35.2010608@pcburn.com>
Date: Thu, 11 Oct 2007 16:48:53 -0400
From: Chris Bergeron <chris@pcburn.com>
Reply-To: chris@pcburn.com
Organization: PCBurn Media
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
References: <4706AD19.4040605@pcburn.com> <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com> <20071011190117.GH4003@csclub.uwaterloo.ca>
In-Reply-To: <20071011190117.GH4003@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Thu, Oct 11, 2007 at 01:02:12PM -0400, Chris Bergeron wrote:
>   
>> One chip has "ITE IT8871F 0641-AYS ZF1M04L" written on it, and the other 
>> two have  a stylized celtic knot looking "T" followed by "TG16C554CJG 
>> FTA6M-001 0620-B".
>>     
>
> The 8871 is a single PCI parallel port, so certainly somehow they are
> controlling the two serial to parallel chips through that pci parallel
> port.
>
> I included the diff of the files you had on your web page and the
> originals founds in 2.4.20 (which is what they claim they replace).
>
> I can't really tell if there is any code there to deal with their quad
> uart chip or not.
>   
I'll see if I can compile up the appropriate kernel and test it with 
that code to see if it includes something to drive the card then, for 
starters.

-- Chris
