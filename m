Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbXLCNOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbXLCNOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXLCNOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:14:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39262 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbXLCNOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:14:46 -0500
Date: Mon, 3 Dec 2007 14:14:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203131442.GA4004@one.firstfloor.org>
References: <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org> <20071203102715.GC28560@one.firstfloor.org> <20071203103815.GA2707@elte.hu> <20071203110412.GD28560@one.firstfloor.org> <20071203115900.GB8432@elte.hu> <20071203121357.GB2986@one.firstfloor.org> <20071203122833.GA20232@elte.hu> <20071203124144.GC2986@one.firstfloor.org> <20071203130003.GA26372@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203130003.GA26372@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> negative 

I would consider it positive, but ok. If I was negative I would 
probably not care and just make always sure to disable SOFTLOCKUP
in the kernels I use.

> feedback about an impending catastrophy has been duly noted 

The point was less about an impending catastrophe, but more of a timebomb
ticking until the next widely used release.

> Can we now please move on to a 
> more productive stage?

Sure no more theory.

To what value do you want to set the backtrace sysctl by default?

-Andi

