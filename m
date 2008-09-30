Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYI3Sop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYI3Sop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYI3SoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:44:23 -0400
Received: from www.tglx.de ([62.245.132.106]:58025 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbYI3SoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:44:22 -0400
Message-Id: <20080930121310.879471299@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 30 Sep 2008 18:44:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>
Subject: [patch 0/3] timer_list: make debug output more useful
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/timer_list resp. sysrq-Q is an important debug helper to analyse
timer related problems. Make it more useful.

Thanks,

	tglx



