Return-Path: <linux-kernel-owner+w=401wt.eu-S1762517AbYBVSR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762517AbYBVSR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbYBVSRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:17:19 -0500
Received: from will39.synserver.de ([212.40.172.10]:50662 "EHLO
	will39.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbYBVSRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:17:18 -0500
Message-ID: <47BF1162.4020805@willies.info>
Date: Fri, 22 Feb 2008 19:16:02 +0100
From: Jan Willies <jan@willies.info>
User-Agent: Thunderbird 2.0.0.9 (X11/20071212)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 100% C0 with 2.6.25-rc
References: <47BD600F.9090502@willies.info> <200802211733.54759.rjw@sisk.pl> <47BEF0A6.9000405@willies.info> <924EFEDD5F540B4284297C4DC59F3DEE9A964C@orsmsx423.amr.corp.intel.com> <47BF0B65.3060900@willies.info> <924EFEDD5F540B4284297C4DC59F3DEE9A967D@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE9A967D@orsmsx423.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
>> -----Original Message-----
>> From: Jan Willies [mailto:jan@willies.info] 
>> Sent: Friday, February 22, 2008 9:50 AM
>> To: Pallipadi, Venkatesh
>> Cc: Rafael J. Wysocki; linux-acpi@vger.kernel.org; Ingo 
>> Molnar; LKML; Thomas Gleixner
>> Subject: Re: 100% C0 with 2.6.25-rc
>>
>> Pallipadi, Venkatesh wrote:
>>> One question. Do you have CONFIG_CPU_IDLE enabled in your confg?
>> Yes, I have. Attached is my .config file
>>
> 
> Can you try with it disabled and check whether you still see the
> problem?

Yup you are right, that fixes the problem as well.


- Jan
