Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYG1Jsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYG1Jsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 05:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYG1Jsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 05:48:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:44998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbYG1Jsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 05:48:41 -0400
Subject: Re: 2.6.24.7-rt16
From: Peter Zijlstra <peterz@infradead.org>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>, Carsten Emde <ce@ceag.ch>,
       Luotao Fu <l.fu@pengutronix.de>
In-Reply-To: <488D7F5D.8090400@grandegger.com>
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0807271719130.574@apollo.tec.linutronix.de>
	 <488D7F5D.8090400@grandegger.com>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 11:48:36 +0200
Message-Id: <1217238516.6331.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 10:12 +0200, Wolfgang Grandegger wrote:

> Thomas Gleixner wrote:

> >      - powerpc ftrace backport (tglx)
> 
> Backport? It's not yet available for 2.6.25.

But it seems to be upstream ;-)

root@twins:/mnt/build/linux-2.6# find arch/powerpc/ | grep ftrace
arch/powerpc/kernel/ftrace.c


