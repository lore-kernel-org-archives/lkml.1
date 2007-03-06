Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbXCFFfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbXCFFfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 00:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933946AbXCFFfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 00:35:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54775
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932649AbXCFFfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 00:35:18 -0500
Date: Mon, 05 Mar 2007 21:35:15 -0800 (PST)
Message-Id: <20070305.213515.48527767.davem@davemloft.net>
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: [PATCH 0/4]: clocksource/clockevents for sparc64
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here is a sequence of 4 patches that add support for dynticks
and high-resolution timers on sparc64.  I've tested this on
SunBlade1500 and a Niagara T1000 system.  I'm about to do
some tests on SunBlade100 as that has the other primary TICK
hardware type.

Any feedback or testing results are appreciated.  All patches
are against Linus's current tree.

Thanks.
