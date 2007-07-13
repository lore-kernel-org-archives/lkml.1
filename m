Return-Path: <linux-kernel-owner+w=401wt.eu-S1763051AbXGMVMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763051AbXGMVMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 17:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbXGMVLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 17:11:51 -0400
Received: from alnrmhc14.comcast.net ([204.127.225.94]:60521 "EHLO
	alnrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949AbXGMVLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 17:11:50 -0400
Subject: Re: [PATCH -rt 6/6] Compile fix for PREEMPT_TIMING on and
	IRQSOFF_TIMING off
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Kevin Hilman <khilman@mvista.com>
Cc: tglx@linutronix.de, mingo@elte.hu, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070713175229.239602308@mvista.com>
References: <20070713175214.336577416@mvista.com>
	 <20070713175229.239602308@mvista.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: The Big Corporation
Date: Fri, 13 Jul 2007 14:11:46 -0700
Message-Id: <1184361106.14224.37.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 10:52 -0700, Kevin Hilman wrote:
> plain text document attachment (trace-cpu-idle.patch)
> 
> The per-cpu trace_cpu_idle variable is used when timing *either*
> IRQs-off or preempt sections.
> 

This also applies to 2.6.22-rt*

Acked-by: Sven-Thorsten Dietrich <sven@thebigcorporation.com>

