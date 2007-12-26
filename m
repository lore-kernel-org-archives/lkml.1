Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbXLZRwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbXLZRwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 12:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXLZRwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 12:52:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57524 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbXLZRwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 12:52:32 -0500
Message-ID: <47729454.40303@kernel.org>
Date: Wed, 26 Dec 2007 09:50:12 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alexey Starikovskiy <aystarik@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Suspend code ordering (again)
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712251713.13223.rjw@sisk.pl> <alpine.LFD.0.9999.0712252006330.21557@woody.linux-foundation.org> <200712261607.18429.rjw@sisk.pl> <47727216.4050003@gmail.com>
In-Reply-To: <47727216.4050003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:
>>
>> I don't know.
>>   
> Windows was compliant only with 1.x spec until Vista.
> With Vista claims are 3.x compliance.
> 

In other words, the 1.x spec is the only thing that matters, at least in 
the short term (*noone* is giving up XP compatibility at this point.)

	-hpa
