Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbZKFWls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbZKFWls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932922AbZKFWlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:41:45 -0500
Received: from www.tglx.de ([62.245.132.106]:53977 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386AbZKFWln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:41:43 -0500
Message-Id: <20091106223547.784916750@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:41:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 00/16] Remove old style lock initializers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old style lock initializers SPIN_LOCK_UNLOCKED and
RW_LOCK_UNLOCKED are deprecated for several years. The series fixes
the remaining users and removes the defines.

Thanks,

	tglx

