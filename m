Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbYANOaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbYANOaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbYANOaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:30:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:38345 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750810AbYANOaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:30:04 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18HF6hknM0Hw5NCnxU2CFVwuxRm9ODzSdbuvLB178
	4VgAguG2kSwuGA
Subject: Re: 2.6.24-rc7-rt1
From: Mike Galbraith <efault@gmx.de>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
In-Reply-To: <1200317101.3733.14.camel@homer.simson.net>
References: <1200250801.9190.7.camel@localhost.localdomain>
	 <200801132143.34889.m.kozlowski@tuxland.pl>
	 <Pine.LNX.4.58.0801131552350.10093@gandalf.stny.rr.com>
	 <1200299260.4665.17.camel@homer.simson.net>
	 <478B0B7C.BA47.005A.0@novell.com>
	 <1200317101.3733.14.camel@homer.simson.net>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 15:29:58 +0100
Message-Id: <1200320998.4249.3.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 14:25 +0100, Mike Galbraith wrote:

> No, I just copied the matching paranoia while leering at it.

Actually, I can't say definitively no, only that a panic() there didn't
make keyboard blink.  Suspend may be disabling blinkies, dunno.

	-Mike

