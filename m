Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbYLEIUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbYLEIUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYLEIUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:20:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59241
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbYLEIUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:20:38 -0500
Date: Fri, 05 Dec 2008 00:20:38 -0800 (PST)
Message-Id: <20081205.002038.141322875.davem@davemloft.net>
To: mingo@elte.hu
Cc: paulus@samba.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       eranian@googlemail.com, dada1@cosmosbay.com, robert.richter@amd.com,
       arjan@infradead.org, hpa@zytor.com, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081205081838.GC2030@elte.hu>
References: <20081205070329.GA30874@elte.hu>
	<20081204.235747.43111785.davem@davemloft.net>
	<20081205081838.GC2030@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 5 Dec 2008 09:18:38 +0100

> Really, you should take a more serious look at our code.

People don't want code, they want a usable port of the PAPI libraries
for profiling.
