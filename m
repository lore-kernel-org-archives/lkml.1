Return-Path: <linux-kernel-owner+w=401wt.eu-S1751672AbZGaPIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbZGaPIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 11:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZGaPI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 11:08:29 -0400
Received: from lider.uludag.org.tr ([193.140.100.216]:37317 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZGaPI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 11:08:28 -0400
Message-ID: <4A7308E8.1000200@pardus.org.tr>
Date: Fri, 31 Jul 2009 18:08:24 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [Bug #13471] Loading parport_pc kills the keyboard if ACPI is
 enabled
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>	<H5-1lZIIeYK.A.dWH.9XObKB@chimera> <20090731151417.568094e5@lxorguk.ukuu.org.uk>
In-Reply-To: <20090731151417.568094e5@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sun, 26 Jul 2009 22:45:29 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
>   
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.29 and 2.6.30.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
>> be listed and let me know (either way).
>>     
>
>
> Ozan - can you confirm it broke between 2.6.29 (ie you tested 2.6.29),
> and 2.6.30-rc1. If so I have an idea what is going on
>   

>From my last comment on bugzilla.kernel.org:

"I tried with 2.6.30.1 but the problem still persists. I really don't have time
to bisect it, but I can help with any other debugging outputs. I also started
think that my board could somehow be faulty as no other people complains about
a similar issue.

Finally, it seems that the problem is available with 2.6.28, so the starting
point is still fuzzy to me. I remember that the keyboard was working OK with
2.6.29_rc7 but now it's not.

Maybe we should drop this report from the regression list."


Monday I'll have access to the computer. I'll build and try to find the last working version.
Meanwhile, I'd like to hear about your possible finding.

Thanks,


