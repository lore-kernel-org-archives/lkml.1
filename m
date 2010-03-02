Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0CBGo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:44:29 -0500
Received: from compulab.co.il ([67.18.134.219]:39060 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0CBGo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:44:28 -0500
Message-ID: <4B8CB370.5080903@compulab.co.il>
Date: Tue, 02 Mar 2010 08:42:56 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: David Brownell <david-b@pacbell.net>,
       Denis Turischev <denis@compulab.co.il>,
       Samuel Ortiz <sameo@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] gpio: add Intel SCH GPIO controller driver
References: <4B73DAEE.5080400@compulab.co.il> <4B7C0DC3.3060907@compulab.co.il> <4B812C21.8000602@compulab.co.il> <201002211112.48527.david-b@pacbell.net> <4B84CC0E.5060203@compulab.co.il> <alpine.LFD.2.00.1003011304500.4281@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003011304500.4281@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
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

Len Brown wrote:
>> I've looked at two x86 drivers in drivers/gpiolib (cs5535 and langwell) and
>> there's no treatment of ACPI in either of them. Since SCH is defined by Intel
>> as "embedded" product, having a GPIO driver for it seems logical even despite
>> problems you mention.
> 
> FWIW
> I believe that Langwell is used only in products without an ACPI BIOS.
> 
> Poulsbo, OTOH, is used in zillions of netbooks running Windows XP.
> I don't know what a cs5535 is.

The cs5535 is AMD Geode LX companion chip which is used with ACPI BIOS 
as well.

> cheers,
> Len Brown, Intel Open Source Technology Center
> 


-- 
Sincerely yours,
Mike.
