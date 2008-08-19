Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbYHSWWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbYHSWWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYHSWWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:22:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49542 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYHSWWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:22:17 -0400
Date: Tue, 19 Aug 2008 15:21:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] merge io_apic_xx.c -- fix
Message-Id: <20080819152156.c79f31e4.randy.dunlap@oracle.com>
In-Reply-To: <20080816133554.GB11063@elte.hu>
References: <1218881249-3028-1-git-send-email-yhlu.kernel@gmail.com>
	<20080816133554.GB11063@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 15:35:54 +0200 Ingo Molnar wrote:

> 
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> >     merge io_apic_xx.c
> > 
> > Thanks
> 
> applied to tip/irq/sparseirq - thanks!


Are there patches in the io_apic series to fix these warnings in linux-next?? ::


linux-next-20080819/arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
linux-next-20080819/arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64


and

linux-next-20080819/arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
linux-next-20080819/arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'




---
~Randy  [i swear people must not look at warnings]

