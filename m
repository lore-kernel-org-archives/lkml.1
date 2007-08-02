Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbXHBMEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbXHBMEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbXHBMEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:04:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:17704 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbXHBMEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=tRULU6V4tSJcepa53ZHFP8pHBOZQZkHviFf3CALEnjg1D55vWPdt1nlqmsmwDDUl6v3MYenNNw4nLz/5yxmU+j6stq15NBy10N+a55iGWn7X1zNQuJ+f4GigYdysqk6/EB87HMHPo2vWdbCllLOl9UJajmLRnNQzWOWXbpYUQP4=
Message-ID: <46B1C835.3060505@googlemail.com>
Date: Thu, 02 Aug 2007 14:04:05 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: trenn@suse.de
CC: Andrew Morton <akpm@linux-foundation.org>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: cpufreq.c:(.text+0xaf178): undefined reference to	`cpufreq_gov_performance'
References: <a44ae5cd0708011631k7f476af2jcd01d2875f4b4b17@mail.gmail.com>	 <20070801165704.a26961b7.akpm@linux-foundation.org> <1186053332.18821.465.camel@queen.suse.de>
In-Reply-To: <1186053332.18821.465.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:
> On Wed, 2007-08-01 at 16:57 -0700, Andrew Morton wrote:
>> On Wed, 1 Aug 2007 16:31:46 -0700
>> "Miles Lane" <miles.lane@gmail.com> wrote:
>>
>>>   LD      .tmp_vmlinux1
>>> drivers/built-in.o: In function `__cpufreq_governor':
>>> cpufreq.c:(.text+0xaf178): undefined reference to `cpufreq_gov_performance'
>>> cpufreq.c:(.text+0xaf18a): undefined reference to `cpufreq_gov_performance'
>>> make: *** [.tmp_vmlinux1] Error 1
>> One for Thomas, I expect.
> 
> Miles, could you send me or point me to the offending .config file.

http://lkml.org/lkml/2007/8/1/480

> 
> Thanks,
> 
>    Thomas


Gabriel
