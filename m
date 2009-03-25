Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZCYE7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZCYE7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZCYE7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:59:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49910 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbZCYE7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:59:09 -0400
Message-ID: <49C9BA02.9070706@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 12:58:42 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: linux-next-20090324: undefined reference to `__this_fixmap_does_not_exist\'
References: <200903250324.n2P3OwX0098272@www262.sakura.ne.jp>
In-Reply-To: <200903250324.n2P3OwX0098272@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa said the following on 2009-3-25 11:24:
> Hello.
> 
> I encountered below error.
> 
> arch/x86/mm/built-in.o(.init.text+0x1831): In function `early_ioremap_init':
> : undefined reference to `__this_fixmap_does_not_exist'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.29-next-20090324
> 

Tetsuo, I've tried the latest tip, it's OK.
I can't trigger the same problem as you do.
So I will try linux-next later.

