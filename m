Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZGUJbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZGUJbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 05:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZGUJbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 05:31:51 -0400
Received: from mail.atmel.fr ([81.80.104.162]:48119 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbZGUJbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 05:31:51 -0400
Message-ID: <4A658AEC.3030000@atmel.com>
Date: Tue, 21 Jul 2009 11:31:24 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
CC: linux-fbdev-devel@lists.sourceforge.net, avictor.za@gmail.com,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       hong.xu@atmel.com
Subject: Re: [PATCH 5/5] at91/atmel_lcdfb: add at91sam9g10 support to atmel
 LCD driver
References: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>	<1245341772-1689-6-git-send-email-nicolas.ferre@atmel.com>	<4A51D2D5.2030707@atmel.com> <20090720152427.b63bb3bd.akpm@linux-foundation.org>
In-Reply-To: <20090720152427.b63bb3bd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton :
> On Mon, 06 Jul 2009 12:32:53 +0200
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> Hi,
>>
>> Nicolas Ferre :
>>> From: Hong Xu <hong.xu@atmel.com>
>>>
>>> Modify atmel LCD driver: atmel_lcdfb for at91sam9g10.  This add a clock
>>> management equivalent to at91sam9261.
>> Can we consider an inclusion in linux-fbdev ?
> 
> The patch looks OK to me.
> 
>>> Signed-off-by: Hong Xu <hong.xu@atmel.com>
>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Andrew Victor added his:
>> Acked-by: Andrew Victor <linux@maxim.org.za>
>>
>>> ---
>>>  drivers/video/Kconfig           |    4 ++--
>>>  drivers/video/atmel_lcdfb.c     |    6 ++++--
>>>  drivers/video/backlight/Kconfig |    2 +-
>>>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> Please merge it via an ARM tree?

Ok, queued in arm patch tracking system with number: 5614/1
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=5614/1

Thanks, Bye,
-- 
Nicolas Ferre

