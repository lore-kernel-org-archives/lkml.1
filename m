Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbYEQE0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbYEQE0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 00:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYEQE0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 00:26:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37898 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYEQE0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 00:26:05 -0400
Date: Sat, 17 May 2008 00:25:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24.7-rt5
In-Reply-To: <1210985943.14697.10.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0805170023270.28686@gandalf.stny.rr.com>
References: <1210985943.14697.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg,

Your patch "sched: push rt tasks only if newly activated tasks have been
added" has caused rt-migrate-test to fail. So I just released 2.6.24.7-rt6
without that patch.

-- Steve

