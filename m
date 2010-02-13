Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab0BMWr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:47:57 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:39669 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619Ab0BMWrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:47:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kWpx+45FIhYdUGe8t13TWjlzgke0iuw6xUC2EaYIcNhjUTNfDmL8jvEY35j06327Kh
         R/yglPhDBGqas8nPbe2JtHj/yirCRXxqqjDDpHgLPUG8DmJRw7t3h9bWDV/f3bNzxMDI
         PB6XLxfV+paV9LI/KILG/tz67pZZHTgZFnp4M=
Message-ID: <4B772C19.90501@pobox.com>
Date: Sat, 13 Feb 2010 17:47:53 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Bart Hartgers <bart.hartgers@gmail.com>
CC: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, juergen.metzdorf@telelev-dsl.de,
       markpschool@hotmail.com, sporadic.crash@gmail.com, apopov@sirma.bg,
       david@coomber.co.za, jay4mail@gmail.com
Subject: Re: [patch 2/2] sata_via: Delay on vt6420 when starting ATAPI DMA
 write
References: <20100116235653.898098245@gmail.com>	 <20100116235851.884756038@gmail.com> <4B5678E2.2050709@gmail.com> <7eb6a4d81001192244k19d28805p9cb4eaec7eed9366@mail.gmail.com> <4B56A8C9.2000807@gmail.com>
In-Reply-To: <4B56A8C9.2000807@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 01:55 AM, Tejun Heo wrote:
> Hello,
>
> On 01/20/2010 03:44 PM, Bart Hartgers wrote:
>> Yes, you're right. I'll drop the printk_once and send another patch
>> for inclusion. However, for testing I found it very useful to make
>> sure that I got the right module loaded. So I figured it could be
>> helpful for the interpretation of success/failure reports.
>
> Oh yeah, for testing, having it there is a good idea.
>
>> Assuming that this patch works for other people as well, what is
>> prefered: resending both patches or just to make a new #2/2 (the
>> vt6420 one)?
>
> I think just re-doing the second patch should be enough.

Agreed...  ping, Bart?

