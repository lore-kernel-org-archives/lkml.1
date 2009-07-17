Return-Path: <linux-kernel-owner+w=401wt.eu-S964825AbZGQOSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbZGQOSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934688AbZGQOSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:18:04 -0400
Received: from www.tglx.de ([62.245.132.106]:48981 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934674AbZGQOSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:18:02 -0400
Date: Fri, 17 Jul 2009 16:17:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Guanqun Lu <guanqun.lu@intel.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, jeremy@goop.org
Subject: Re: [PATCH 1/3] add flag IRQF_NO_SUSPEND in 'struct irqaction'
In-Reply-To: <200907170352.11749.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0907171615530.11571@localhost.localdomain>
References: <1247834204-3084-1-git-send-email-guanqun.lu@intel.com> <200907170352.11749.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, Rafael J. Wysocki wrote:

> On Friday 17 July 2009, Guanqun Lu wrote:
> > We currently only bypass IRQF_TIMER in '__disable_irq',
> > but Xen specific IRQs should not be disabled either.
> > This commit adds a new flag to accompolish this goal
> > without being mixed up with IRQF_TIMER flag.
> 
> For some obscure reasons [2/3] didn't reach my inbox.  The other 2 patches
> look fine to me.

I do not receive the patches at all. Can you please resend and cc me ?

Thanks,

	tglx
