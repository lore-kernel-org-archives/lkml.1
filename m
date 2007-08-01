Return-Path: <linux-kernel-owner+w=401wt.eu-S1765628AbXHAP1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765628AbXHAP1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765494AbXHAP0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:26:54 -0400
Received: from neon.samage.net ([85.17.153.66]:35090 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765459AbXHAP0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:26:51 -0400
Message-ID: <52091.81.207.0.53.1185982005.squirrel@secure.samage.net>
In-Reply-To: <20070801150939.GA24710@elte.hu>
References: <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>
    <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>
    <46B06815.10200@gmail.com>
    <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>
    <46B0818F.10204@gmail.com>
    <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
    <46B08B95.2010405@kvitka.net> <46B09190.1070201@gmail.com>
    <46850.81.207.0.53.1185980760.squirrel@secure.samage.net>
    <20070801150939.GA24710@elte.hu>
Date: Wed, 1 Aug 2007 17:26:45 +0200 (CEST)
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
From: "Indan Zupancic" <indan@nul.nu>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Rene Herman" <rene.herman@gmail.com>, teresa@kvitka.net,
       "Andi Kleen" <andi@firstfloor.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "CK Mailinglist" <ck@vds.kolivas.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 51a43cd7ff6838d9e9bce89dbcde6c26
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, August 1, 2007 17:09, Ingo Molnar wrote:
>
> * Indan Zupancic <indan@nul.nu> wrote:
>
>> We could have independent problems with more or less the same
>> symptoms, at least Teresa's problem seems much worse than ours, and if
>> you and Ingo only experience a stuck delete key, it might be something
>> else.
>
> i experienced nothing in this area so far - if i experienced anything of
> the likes it would be long fixed! =B-)

Ah, indeed, you appended Rene's email without too many new lines,
so I thought your wrote it (http://lkml.org/lkml/2007/8/1/4).

All right, how would you debug it? Give us some insight in how to solve
hard to trigger, happens at most only a few times a day, annoying input
bug? I thought the mouse warping was fixed after 23-rc1 and that input
locking patch, but alas, the third day it happened again.

I would be happy just to know if it's bad hardware or a software bug,
I don't ask for too much, do I?

Greetings,

Indan


