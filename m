Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbXFWVcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbXFWVcn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 17:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXFWVcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 17:32:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53290 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbXFWVcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 17:32:36 -0400
Subject: Re: [patch -mm 26/28] x86-64 block irq balancing for timer
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070623124031.301753868@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
	 <20070623124031.301753868@inhelltoy.tec.linutronix.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 23 Jun 2007 14:27:20 -0700
Message-Id: <1182634040.2910.7.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-23 at 13:32 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (x86-64-clockevents-irq-balancing.patch)
> From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
> 
> Disable irq balancing on IRQ0.


this patch is missing some rationale....

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

