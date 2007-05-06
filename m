Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbXEFVCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbXEFVCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXEFVCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:02:31 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3392 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025AbXEFVC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:02:29 -0400
Date: Sun, 6 May 2007 16:48:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Jiri Benc <jbenc@suse.cz>, netdev@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mac80211: include <linux/delay.h> instead of <asm/delay.h>
Message-ID: <20070506204826.GA11238@tuxdriver.com>
References: <Pine.LNX.4.64.0705062236030.4741@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705062236030.4741@anakin>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 10:37:17PM +0200, Geert Uytterhoeven wrote:
> |   CC      net/mac80211/ieee80211_sta.o
> | In file included from linux/net/mac80211/ieee80211_sta.c:31:
> | include2/asm/delay.h: In function '__const_udelay':
> | include2/asm/delay.h:33: error: 'loops_per_jiffy' undeclared (first use in this function)
> | include2/asm/delay.h:33: error: (Each undeclared identifier is reported only once
> | include2/asm/delay.h:33: error: for each function it appears in.)
> 
> mac80211: include <linux/delay.h> instead of <asm/delay.h>

Got it, thanks!

Please send/copy to linux-wireless@vger.kernel.org in the future.

John
-- 
John W. Linville
linville@tuxdriver.com
