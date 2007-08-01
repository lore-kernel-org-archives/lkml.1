Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbXHANHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbXHANHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761576AbXHANH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:07:28 -0400
Received: from neon.samage.net ([85.17.153.66]:47620 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955AbXHANH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:07:27 -0400
Message-ID: <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
In-Reply-To: <46B0818F.10204@gmail.com>
References: <1185827130.26459.16.camel@xtower.fri>
    <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>
    <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>
    <46B06815.10200@gmail.com>
    <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>
    <46B0818F.10204@gmail.com>
Date: Wed, 1 Aug 2007 15:07:20 +0200 (CEST)
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
From: "Indan Zupancic" <indan@nul.nu>
To: "Rene Herman" <rene.herman@gmail.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "CK Mailinglist" <ck@vds.kolivas.org>, teresa@kvitka.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 938925967a2432a0d8c7279c30be63be
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, August 1, 2007 14:50, Rene Herman wrote:
> On 08/01/2007 02:34 PM, Indan Zupancic wrote:
>
>> On Wed, August 1, 2007 13:01, Rene Herman wrote:
>
>>> Teresa was already using 2.6.22.1, with CFS (v19.1) patched in, so reverting
>>> that would be a matter of patching it out again. She said she wasn't seeing
>>> trouble on other kernels though.
>>>
>>> I was the one who also saw keyboard trouble on 2.6.22.1 without CFS by the
>>> way -- and haven't (yet) seen any anymore since patching _in_ CFS v19.1...
>>
>> Could the people who had or have keyboard problems try out Dmitry's
>> input locking patches, and see if those help: http://lkml.org/lkml/2007/7/24/17
>> And if it does, report it to him, either there or here after CCing him.
>
> I'm having trouble reproducing this at will -- it sounded as though Teresa
> had less trouble at least originally. Teresa?

Same here, so testing is a pain. I was more thinking about running a patched
version for a day or longer and see if it happened or not. For me it happened
irregularly, but definitely a few times a day.

(It might help if people report what they're using. So, for what it's worth, I'm
using a PS/2 keyboard with xorg 1.2.0 with the "keyboard" driver.)

Greetings,

Indan


