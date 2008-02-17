Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYBQQ6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYBQQ6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYBQQ6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:58:01 -0500
Received: from www.tglx.de ([62.245.132.106]:36397 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbYBQQ6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:58:00 -0500
Date: Sun, 17 Feb 2008 17:57:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?UTF-8?Q?S=2E=C3=87a=C4=9Flar_Onur?= <caglar@pardus.org.tr>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 13/14] kernel/irq/spurious.c: Use time_* macros
In-Reply-To: <1203003412-11594-14-git-send-email-caglar@pardus.org.tr>
Message-ID: <alpine.LFD.1.00.0802171757020.7583@apollo.tec.linutronix.de>
References: y <1203003412-11594-14-git-send-email-caglar@pardus.org.tr>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-783684684-1203267450=:7583"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-783684684-1203267450=:7583
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 14 Feb 2008, S.Çağlar Onur wrote:

> The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.
> 
> So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Applied. Thanks,

	 tglx
--8323328-783684684-1203267450=:7583--
