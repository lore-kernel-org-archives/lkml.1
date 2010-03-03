Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0CCGn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:43:58 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47043 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab0CCGn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:43:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 3 Mar 2010 15:40:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-03-02-18-38 uploaded
Message-Id: <20100303154022.d5f10b70.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201003030305.o2335F1F015917@imap1.linux-foundation.org>
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Mar 2010 18:39:07 -0800
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-03-02-18-38 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.33:
> 
> origin.patch

Just for sharing information.

you may need this patch for booting.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9599945bac93b344519ea97f502cf537124b5a6e;hp=13dda80e48439b446d0bc9bab34b91484bc8f533


Thanks,
-Kame

