Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYLSRNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYLSRNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYLSRNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:13:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:38969 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbYLSRNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:13:18 -0500
Subject: perf_counter.c hw_perf_enable_all() is unused
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       perfctr-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Fri, 19 Dec 2008 22:41:27 +0530
Message-Id: <1229706687.7625.9.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

In arch/x86/kernel/cpu/perf_counter.c hw_perf_enable_all() is unused.

Are you keeping it for future reference.

Thank you,

Jaswinder Singh.

