Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbXGJO05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbXGJO05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 10:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbXGJO0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 10:26:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:53513 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882AbXGJO0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 10:26:50 -0400
In-Reply-To: <20070710105212.GA14682@iram.es>
References: <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org> <464C9E67.2020909@ru.mvista.com> <6E0D5E13-C939-4FCE-81A3-F29DFA6436A2@kernel.crashing.org> <464CA222.8000407@ru.mvista.com> <464D9E7E.3090605@genesi-usa.com> <464DADFC.3080802@ru.mvista.com> <464DB800.40702@genesi-usa.com> <1179499713.12981.75.camel@chaos> <32E780BE-58B7-4303-AA49-1852C4C7EB50@kernel.crashing.org> <464DD9DD.8030603@genesi-usa.com> <20070710105212.GA14682@iram.es>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <78777AB0-8FA2-4FB0-9D02-6504ED28957D@kernel.crashing.org>
Cc: Matt Sealey <matt@genesi-usa.com>, linuxppc-dev@ozlabs.org,
       Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Date: Tue, 10 Jul 2007 16:24:07 +0200
To: Gabriel Paubert <paubert@iram.es>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This scales with the number of processors since there is one
> decrementer per core (is it per thread on SMT chips?
> I don't know).

One per core.


Segher

