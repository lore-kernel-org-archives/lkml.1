Return-Path: <linux-kernel-owner+w=401wt.eu-S1761432AbXK1Pq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761432AbXK1Pq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbXK1Pqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:46:51 -0500
Received: from services.erkkila.org ([24.97.94.217]:42364 "EHLO erkkila.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950AbXK1Pqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:46:50 -0500
Message-ID: <474D8D66.4090608@erkkila.org>
Date: Wed, 28 Nov 2007 10:46:46 -0500
From: Paul Erkkila <pee@erkkila.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: ACPI related Warning in 2.6.24-rc3-git2
References: <20071127150557.GA4365@ics.muni.cz> <200711271637.13036.rjw@sisk.pl> <20071128041155.GB18131@khazad-dum.debian.net> <20071128083153.GL4365@ics.muni.cz> <474D7336.4000102@erkkila.org> <20071128152700.GO4985@kernel.dk>
In-Reply-To: <20071128152700.GO4985@kernel.dk>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Nov 28 2007, Paul Erkkila wrote:
>> Lukas Hejtmanek wrote:
>>> On Wed, Nov 28, 2007 at 02:11:55AM -0200, Henrique de Moraes Holschuh wrote:
>>>> On Tue, 27 Nov 2007, Rafael J. Wysocki wrote:
>>>>>> in recent kernel, I got the following warnings while booting. It's ACPI
>>>>>> related. Does anybode care? Lenovo ThinkPad T61 (6465CTO).
>>>> Could we know the BIOS version, please?
>>> 7LET56WW (1.26 ) (according to hal, 1.26 is definitely correct, can be seen in
>>> BIOS as well)
>>>
>> I'm seeing the same thing here, on a similar machine ( 6459CTO ). I
>> pulled the source from kernel git last night to test it.
>>
>>
>> Bios:
>> thinkpad_acpi: ThinkPad BIOS 7LET56WW (1.26 ), EC 7KHT22WW-1.06
> 
> I reported the same thing yesterday:
> 
> http://lkml.org/lkml/2007/11/27/228
> 
> x60 here, latest BIOS.
> 

dmesg output
http://pee.erkkila.org/dump/dmesg-4.txt

config
http://pee.erkkila.org/dump/config-4.txt

-pee
