Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbYJUUsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbYJUUsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYJUUsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:48:23 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:9438 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYJUUsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:48:23 -0400
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <48FE400C.2070005@tremplin-utc.net>
Date: Tue, 21 Oct 2008 22:48:12 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, burman.yan@gmail.com, pau@eslack.org
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
References: <48FA3368.1040605@tremplin-utc.net> <20081021114121.5144841c.akpm@linux-foundation.org> <48FE2525.90701@oracle.com>
In-Reply-To: <48FE2525.90701@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap schreef:
> Andrew Morton wrote:
>> On Sat, 18 Oct 2008 21:05:12 +0200
>> Eric Piel <eric.piel@tremplin-utc.net> wrote:
>>
>>> ...
>>>
>>> +/**
>>> + * lis3lv02d_acpi_read() - ACPI ALRD method: read a register
>> All the kerneldoc comments include the () after the function name. 
>> That is unconventional and I do not know what effect it will have upon
>> kerneldoc processing and output.
> 
> Yes, it's unconventional.
> It works.  It (the "()") will be dropped when processed.
I simply followed the style used in the very first example of the
documentation (kernel-doc-nano-HOWTO.txt). Anyhow, I can drop the "()",
I'm not attached to them too much ;-)

See you,
Eric
