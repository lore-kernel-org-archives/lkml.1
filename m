Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZCDL3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZCDL3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZCDL3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:29:23 -0500
Received: from relay.atmel.no ([80.232.32.139]:56381 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbZCDL3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:29:22 -0500
Message-ID: <49AE65FF.2060309@atmel.com>
Date: Wed, 04 Mar 2009 12:29:03 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: Re: [PATCH 0/5] WM97xx updates
References: <20090303182402.GA29542@rakim.wolfsonmicro.main> <20090304091538.GD7394@dtor-d630.eng.vmware.com> <49AE492F.6020006@atmel.com> <20090304105358.GA32107@rakim.wolfsonmicro.main>
In-Reply-To: <20090304105358.GA32107@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Wed, Mar 04, 2009 at 10:26:07AM +0100, Hans-Christian Egtvedt wrote:
> 
>> The only thing catched by review was a leaking irq line, do you plan to  
>> fixup that Mark?
> 
> Jiri also had some further comments from the initial posting (mail
> attached).  I can probably try to fix up most things blind but I'll need
> to at least set up an at32 toolchain to build test.  The workqueue thing
> might be better to test on hardware, though, just in case there's some
> noticable performance impact.  I wouldn't expect so but it'd be safer.
> 

I'll see what I can manage to squeeze in of testing, there is always the 
in-between-time.

What is this patch based against? Linus tree, master branch?

-- 
Best regards,
Hans-Christian Egtvedt
