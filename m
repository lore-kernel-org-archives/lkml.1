Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZF2MWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZF2MWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZF2MWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:22:12 -0400
Received: from legaljet.webserversystems.com ([67.18.134.218]:56696 "EHLO
	compulab.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZF2MWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:22:11 -0400
Message-ID: <4A48B1D9.90306@compulab.co.il>
Date: Mon, 29 Jun 2009 15:21:45 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: Michael Opdenacker <michael-lists@free-electrons.com>,
       Florian Fainelli <florian@openwrt.org>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-embedded mailing list <linux-embedded@vger.kernel.org>
Subject: Re: Status of bzip2 and lzma kernel compression for ARM?
References: <4A428AFF.20307@free-electrons.com> <4A433BCD.2030506@compulab.co.il> <200906251104.02830.florian@openwrt.org> <4A4396CB.9000703@free-electrons.com> <4A4776DD.50105@knaff.lu> <4A478286.8020908@knaff.lu>
In-Reply-To: <4A478286.8020908@knaff.lu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alain Knaff wrote:
> Alain Knaff wrote:
>> Attached is a version of the ARM patch for 2.6.30
>>
>> There seems to be some issues with the include files (which did not pose
>> any problems in 2.6.28...), but hopefully somebody more experienced with
>> the ARM architecture (and with its recent development) than I can help
>> out there.
>>
>> Regards,
>>
>> Alain
> 
> Actually, the needed changes turned out to be easier than I initially
> feared. Attached a version that compiles all right.

I gave it a quick test and it hangs before "Decompressing kernel" is output.
I hope I'll have time this week to debug what's wrong there.

> Regards,
> 
> Alain
> 

-- 
Sincerely yours,
Mike.

