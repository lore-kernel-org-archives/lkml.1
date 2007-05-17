Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbXEQPlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbXEQPlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 11:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbXEQPlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 11:41:15 -0400
Received: from dedi.luli.de ([88.198.62.74]:35669 "EHLO dedi.luli.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbXEQPlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 11:41:14 -0400
Message-ID: <464C779C.90009@rootdir.de>
Date: Thu, 17 May 2007 17:41:16 +0200
From: Claas Langbehn <claas@rootdir.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: This kernel requires the following features not present on the
 CPU... (on a VIA C7 CPU)
References: <464C4A22.7040709@rootdir.de> <20070517162403.2ff0e3b5@the-village.bc.nu>
In-Reply-To: <20070517162403.2ff0e3b5@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Concerning the crashes I already changed the memory module, but with no 
>> success. I'm not sure
>> wether this is a hardware or software bug.
>>     
>
> Testing with memtest86 should help tell you if the problem is a dodgy
> DIMM specifically rather than another hardware or software fault.
>   

I already did this. I had a broken aeneon DIMM at first. I got a new 
working one.
But the crashes were still there. Then I got a samsung DIMM instead and 
it did
not get better. Therefore I think that the memory is not causing this.

Actually the system freezes when I click somewhere with my USB mouse, even
with no load at all. Unfortunately the system does not have a serial 
port for
a serial console. Netconsole was not working with the via-rhine. I wanted to
try serial console over ttyUSB, but I did not have time for it, yet.


Claas
