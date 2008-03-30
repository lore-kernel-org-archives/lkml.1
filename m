Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbYC3UWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbYC3UWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbYC3UWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:22:36 -0400
Received: from rtr.ca ([76.10.145.34]:2582 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbYC3UWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:22:35 -0400
Message-ID: <47EFF689.5030506@rtr.ca>
Date: Sun, 30 Mar 2008 16:22:33 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: bugme-daemon@bugzilla.kernel.org, rjw@sisk.pl, bunk@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [Bug 10345] USB HID problems after resume
References: <20080328223544.A61F711D10C@picon.linux-foundation.org> <47EE78C9.5090006@rtr.ca> <47EE793C.5070105@rtr.ca> <20080330114834.GA6510@elf.ucw.cz> <47EFD1F1.8010501@rtr.ca> <20080330182243.GA11839@elf.ucw.cz> <47EFF4F6.1050302@rtr.ca> <20080330202047.GE11839@elf.ucw.cz>
In-Reply-To: <20080330202047.GE11839@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>> 3GB of RAM? Try iommu=soft.
..
>>
>> This is a 32-bit system / kernel, so I'm guessing that this option is not applicable.
>>
>> Right?  (it does have 3GB of RAM, though).
> 
> Not 100% sure... I've seen strangeness on 32-bit systems, too. Can you
> simply pass mem=2G and see what happens?
..

Sure, after I finish collecting data on the problem, I'll give that a try.
It will be somewhat inconclusive, though, since the problem does not happen
on every resume.  

cheers

