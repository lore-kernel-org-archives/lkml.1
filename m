Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbXFLM5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbXFLM5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbXFLM5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:57:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:54316 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbXFLM5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:57:38 -0400
Message-ID: <466E983E.1070607@windriver.com>
Date: Tue, 12 Jun 2007 08:57:34 -0400
From: Bruce Ashfield <bruce.ashfield@windriver.com>
Reply-To: bruce.ashfield@windriver.com
Organization: Wind River
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Can we get rid of zImage this time?
References: <466DE04C.4020303@zytor.com> <3bd6b93c0706111920p36d866a6m18915696fd386473@mail.gmail.com> <466E39B4.1040400@zytor.com>
In-Reply-To: <466E39B4.1040400@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Bruce Ashfield wrote:
>> These beasts are still alive and kicking. I boot a handful of
>> arm and ppc boards on a frequent basis that are zImage
>> only.  The kicker is I don't have the bootloader source for
>> most of them, so changing to a different image format is
>> tough at best.
>>
> 
> Sorry, the zImage/bzImage distinction is x86 only.  Some other
> architectures call their output zImage, but it's a different format
> entirely.
> 
> So I was referring specifically to x86.

Ah my mistake, I quickly scanned and didn't pick
up the x86 reference. Nothing to see here :)

Bruce

> 
> 	-hpa

