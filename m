Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbYFGJqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbYFGJqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 05:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbYFGJqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 05:46:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54077 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbYFGJqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 05:46:36 -0400
Subject: Re: [rtc-linux] Re: state of GEN_RTC vs rtc subsystem
From: David Woodhouse <dwmw2@infradead.org>
To: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, rz@linux-m68k.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <484473E6.5060400@am.sony.com>
References: <47B18612-66A3-476C-B81C-F2FD11CE9A64@kernel.crashing.org>
	 <20080220180325.46446675@i1501.lan.towertech.it>
	 <48408394.8000406@am.sony.com>  <484473E6.5060400@am.sony.com>
Content-Type: text/plain
Date: Sat, 07 Jun 2008 10:46:26 +0100
Message-Id: <1212831986.32207.416.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-02 at 15:27 -0700, Geoff Levand wrote:
> 
> Just to follow up, I found that David Woodhouse has submitted
> a patch which does this:
> 
>    http://patchwork.ozlabs.org/linuxppc/patch?id=18139

It's merged now:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=aabe1885

-- 
dwmw2

