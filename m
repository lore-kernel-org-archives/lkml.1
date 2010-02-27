Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968291Ab0B0NBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 08:01:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49734 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968249Ab0B0NBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 08:01:48 -0500
Date: Sat, 27 Feb 2010 14:01:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, ebiederm@xmission.com,
       garyhade@us.ibm.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, trenn@suse.de
Subject: Re: [tip:x86/apic] x86: Fix out of order gsi -- add
 remap_ioapic_gsi_to_irq()
Message-ID: <20100227130113.GA18661@elte.hu>
References: <4B882182.4030205@kernel.org>
 <tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Causes:

 arch/x86/kernel/apic/io_apic.c:1042: error: implicit declaration of function ?remap_ioapic_gsi_to_irq?

Please send delta fix.

Thanks,

	Ingo
