Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbYHTN2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbYHTN2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbYHTN14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:27:56 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:65520 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYHTN14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:27:56 -0400
Date: Wed, 20 Aug 2008 22:27:57 +0900 (JST)
Message-Id: <20080820.222757.61509491.anemo@mba.ocn.ne.jp>
To: akpm@linux-foundation.org
Cc: david-b@pacbell.net, rmk+lkml@arm.linux.org.uk, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] rtc uie emulation deadlocks
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080819131546.51dea318.akpm@linux-foundation.org>
References: <20080819005320.00075dba.akpm@linux-foundation.org>
	<915094.18966.qm@web82205.mail.mud.yahoo.com>
	<20080819131546.51dea318.akpm@linux-foundation.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 13:15:46 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> > I'm sure I saw someone else's fixup patch for that a couple weeks ago.
> > (Looks).  Yes:
> > 
> > http://groups.google.com/group/rtc-linux/browse_thread/thread/ad65b883739f8c92#
> 
> argh, so a fix for a serious regression has been languishing in the
> backwaters of the rtc list for two weeks.
> 
> Guys, please: regressions are serious, top-priority emergencies.  We
> drop everything and run around with our hair on fire when we hear about
> one (don't we?).  Please, if you have a report of a regression or a fix
> for one, Cc: everyone in the world on it.

Oh, I had thought I CC-ed it to LKML but actually I didn't.  Thank you
for catching it up anyway.

---
Atsushi Nemoto
