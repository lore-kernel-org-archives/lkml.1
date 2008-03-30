Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbYC3Rqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbYC3Rqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 13:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYC3Rq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 13:46:28 -0400
Received: from rtr.ca ([76.10.145.34]:4294 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbYC3Rq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 13:46:27 -0400
Message-ID: <47EFD1F1.8010501@rtr.ca>
Date: Sun, 30 Mar 2008 13:46:25 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: bugme-daemon@bugzilla.kernel.org, rjw@sisk.pl, bunk@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [Bug 10345] USB HID problems after resume
References: <20080328223544.A61F711D10C@picon.linux-foundation.org> <47EE78C9.5090006@rtr.ca> <47EE793C.5070105@rtr.ca> <20080330114834.GA6510@elf.ucw.cz>
In-Reply-To: <20080330114834.GA6510@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sat 2008-03-29 13:15:40, Mark Lord wrote:
>..
>> Just happened again.  The machine resumed from RAM with no functioning USB.
>> Still running the exact same 2.6.25-rc7 kernel as before, with the RTC conflict fixed.
>>
>> WTF?
> 
>> 3GB of RAM? Try iommu=soft.
..

What does that option do (it is not in Documentation/kernel-parameters.txt),
and why do you suspect it may make a difference here?

Thanks
