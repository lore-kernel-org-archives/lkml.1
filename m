Return-Path: <linux-kernel-owner+w=401wt.eu-S1762119AbXGPTxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762119AbXGPTxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758839AbXGPTxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:53:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37210 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758288AbXGPTxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:53:19 -0400
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
From: Arjan van de Ven <arjan@infradead.org>
To: linux@bohmer.net
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, mathieu.desnoyers@polymtl.ca,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 16 Jul 2007 12:52:37 -0700
Message-Id: <1184615557.2698.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-16 at 21:46 +0200, Remy Bohmer wrote:
> So I was wondering if anybody knows some tool/kernel mechanism which
> can do this?
> If not, I will build a kernel extension for it myself (new extension
> to 'latency_trace' ?)

systemtap has been able to do such things for me in the past...

-- 
if you want to mail me at work (you don't), use arjan (at)
linux.intel.com
Test the interaction between Linux and your BIOS via
http://www.linuxfirmwarekit.org

