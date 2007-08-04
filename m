Return-Path: <linux-kernel-owner+w=401wt.eu-S1763006AbXHDLZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763006AbXHDLZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 07:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbXHDLZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 07:25:29 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:51680 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbXHDLZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 07:25:28 -0400
Date: Sat, 4 Aug 2007 14:25:27 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Kconfig: 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
Message-ID: <Pine.SOC.4.64.0708041425020.26419@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is arcch/ppc:

kernel/power/Kconfig:84:warning: 'select' used by config symbol 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'

-- 
Meelis Roos (mroos@linux.ee)
