Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbYFKU3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbYFKU3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbYFKU0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:26:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59573 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbYFKU01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:26:27 -0400
Message-ID: <485031FA.6070303@zytor.com>
Date: Wed, 11 Jun 2008 13:13:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Keith Roberts <keith@karsites.net>
CC: devzero@web.de, linux-kernel@vger.kernel.org
Subject: Re: Problems with edd
References: <311993399@web.de> <484F10A9.4030606@zytor.com> <alpine.LFD.1.10.0806112102350.18067@www.karsites.net>
In-Reply-To: <alpine.LFD.1.10.0806112102350.18067@www.karsites.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Roberts wrote:
>>
>> I have put in syslinux 3.70-pre16 code to print the source of this 
>> message.  You may want to try to grab isolinux from this release and 
>> update your CD image to get some useful debugging info out of this.
>>
>>     -hpa
> 
> Not being a kernel guru, I'm not sure how to do that hpa?
> 
> Where do I get isolinux from please?
> 

ftp://ftp.kernel.org/pub/linux/utils/boot/syslinux/Testing/syslinux-3.70-pre16.tar.bz2

> how do I update my CD image?

You will need to run mkisofs with the same options used to generate the 
image.

In a pinch, if you can point me to the original ISO I could try to 
doctor it.

> I'm willing to give this a try if it will sort out the problem.

That would be useful.  This is potentially a previously unreported BIOS 
issue which might have a straightforward workaround, so I'm eager to get 
the data.

	-hpa
