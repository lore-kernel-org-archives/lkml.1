Return-Path: <linux-kernel-owner+w=401wt.eu-S932689AbZKXKiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbZKXKiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932669AbZKXKiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:38:13 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:48984 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655AbZKXKiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:38:12 -0500
Message-ID: <4B0BB793.4040407@monstr.eu>
Date: Tue, 24 Nov 2009 11:38:11 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       grant.likely@secretlab.ca, john.williams@petalogix.com,
       stable@kernel.org, chrisw@sous-sol.org, greg@kroah.com,
       alonz@discretix.com
Subject: Re: [PATCH] serial: 8250: Add ns16550a to OF compatible list
References: <1259054502-28284-1-git-send-email-monstr@monstr.eu> <200911240953.52204.arnd@arndb.de> <4B0BB393.4050302@monstr.eu> <200911241033.27938.arnd@arndb.de>
In-Reply-To: <200911241033.27938.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Tuesday 24 November 2009 10:21:07 Michal Simek wrote:
>> Arnd Bergmann wrote:
>>
>> it is simple almost trivial patch but if you like I can write there some 
>> background.
> 
> Already submitted again with some text
>  
>>> * You did not cc me. Ok, I just noticed I'm missing an entry in the MAINTAINERS
>>> file, but scripts/get_maintainer.pl would have given you a good indication of
>>> who feels responsible. You also didn't cc Alon, who submitted a similar patch
>>> [1] just days ago, which I assume prompted you to send this. If you didn't see
>>> his patch, nevermind.
>> you are not there. I have never used get_maintainer.pl script - will do.
>>
>> I haven't seen his patch in LKML. Which subject?
> 
> see the link at the bottom of my mail, referenced through "[1]" above.
> It was cross-posted on some mailing lists, but unfortunately not on lkml.

:-)

> 
>> $ ./scripts/get_maintainer.pl -f drivers/serial/8250.c
>> Alan Cox <alan@linux.intel.com>
>> Andrew Morton <akpm@linux-foundation.org>
>> David Daney <ddaney@caviumnetworks.com>
>> Tomaso Paoletti <tpaoletti@caviumnetworks.com>
>> Greg Kroah-Hartman <gregkh@suse.de>
>> linux-serial@vger.kernel.org
>> linux-kernel@vger.kernel.org
>  
> wrong file: 
> ./scripts/get_maintainer.pl -f drivers/serial/of_serial.c
> Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Arnd Bergmann <arnd@arndb.de>
> Matthias Fuchs <mfuchs@ma-fu.de>
> Dave Mitchell <dmitchell@amcc.com>
> Andrew Morton <akpm@linux-foundation.org>
> Grant Likely <grant.likely@secretlab.ca>
> linux-kernel@vger.kernel.org
> devicetree-discuss@lists.ozlabs.org

aaa. Anyway - you forget cc me. :-)

Michal

> 
>>> [1] http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg39015.html
>>> [2] http://lkml.indiana.edu/hypermail/linux/kernel/0504.3/1369.html
> 
> 	Arnd <>< 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
