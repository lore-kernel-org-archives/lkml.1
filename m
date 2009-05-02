Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbZEBUBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbZEBUBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZEBUB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:01:29 -0400
Received: from www.tglx.de ([62.245.132.106]:55701 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbZEBUB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:01:29 -0400
Message-Id: <20090502195607.539955644@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 20:00:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 00/11] Remove obsolete genirq defines and typedefs [Resend]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<http://lkml.org/lkml/2009/3/10/497>

The defines and typedefs (hw_interrupt_type, no_irq_type, irq_desc_t)
have been kept around for migration reasons. After more than two years
it's time to remove them finally.

This patch series cleans up the remaining users. When those patches
hit mainline we can remove the defines and typedefs finally.

</http://lkml.org/lkml/2009/3/10/497>

These are the not yet applied parts of the original patch series.

Thanks,

        tglx

