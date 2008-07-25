Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbYGYJMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbYGYJMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYGYJM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:12:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:13000 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbYGYJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DN+cWOur+/Gcfbj8Ab1z1QX96+KgIUTTlHowUPrZQyCfPrJkTIJuQkwc3AH83sKu/5
         RV0J7/s2Ws2zBstepPTZq3fBLDC+i1B4HX0IFoUxEbXvEZlJUAEaRaafxRCKPUfzRatE
         pTXJihuXhd14lxPGdZZMkTrkbryp1nWVOxh2o=
Message-ID: <aec7e5c30807250212p323a281cu484b8789215f328b@mail.gmail.com>
Date: Fri, 25 Jul 2008 18:12:28 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 00/06] uio: Various minor changes
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
In-Reply-To: <20080718154624.GE3284@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
	 <20080718154624.GE3284@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Sat, Jul 19, 2008 at 12:46 AM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Fri, Jul 18, 2008 at 02:04:02PM +0900, Magnus Damm wrote:
>> Hi everyone,
>>
>> Here comes a few UIO changes that I've had in my queue for a while.
>
> Hi Magnus,
> thanks a lot for your patches. I'll have a look at them ASAP, but it'll
> take a few days. I'm busy moving to a new house ATM...

No problem. There is nothing in this series that must be included in
2.6.27 in my opinion, so take your time.

I do however wish to have the uio_pdrv_genirq driver included in
2.6.27. I've seen the uio_pdrv driver and the irqcontrol patches in
linux-2.6.git, but the uio_pdrv_genirq driver is still missing...
Should I repost?

Thanks for your help,

/ magnus
