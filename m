Return-Path: <linux-kernel-owner+w=401wt.eu-S934944AbXGMSPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934944AbXGMSPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933425AbXGMSNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:13:15 -0400
Received: from deeprooted.net ([216.254.16.51]:38943 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760310AbXGMSNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:13:07 -0400
Message-Id: <20070713175214.336577416@mvista.com>
User-Agent: quilt/0.45-1
Date: Fri, 13 Jul 2007 10:52:14 -0700
From: Kevin Hilman <khilman@mvista.com>
To: tglx@linutronix.de, mingo@elte.hu
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -rt 0/6] misc. ARM fixup and compile fixes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, Ingo,

Here's a handful of small fixes for -rt3.  They are either ARM-related
fixups or compile fixes for various .config combinations.

The first couple I already reported, but here they're all together.

Kevin

--
