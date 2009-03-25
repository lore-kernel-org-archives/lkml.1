Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZCYIwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZCYIwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZCYIwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:52:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60696 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbZCYIwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:52:43 -0400
Message-ID: <49C9F0CB.2000807@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 16:52:27 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: linux-next-20090324: undefined reference to `__this_fixmap_does_not_exist\'
References: <200903250324.n2P3OwX0098272@www262.sakura.ne.jp> <49C9BA02.9070706@cn.fujitsu.com>
In-Reply-To: <49C9BA02.9070706@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang Chen said the following on 2009-3-25 12:58:
> Tetsuo Handa said the following on 2009-3-25 11:24:
>> Hello.
>>
>> I encountered below error.
>>
>> arch/x86/mm/built-in.o(.init.text+0x1831): In function `early_ioremap_init':
>> : undefined reference to `__this_fixmap_does_not_exist'
>> make: *** [.tmp_vmlinux1] Error 1
>>
>> Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.29-next-20090324
>>
> 
> Tetsuo, I've tried the latest tip, it's OK.
> I can't trigger the same problem as you do.
> So I will try linux-next later.
> 

Tetsuo

I've "make" tested linux-next-20090324 with your config.
Still can't trigger the error.
It's strange :(

