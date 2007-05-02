Return-Path: <linux-kernel-owner+w=401wt.eu-S2992524AbXEBAeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992524AbXEBAeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992536AbXEBAeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:34:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992524AbXEBAeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:34:12 -0400
Date: Tue, 1 May 2007 17:33:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [patch 0/3] Clocksource / clockevent updates
Message-Id: <20070501173356.15e9d482.akpm@linux-foundation.org>
In-Reply-To: <20070430102837.748238000@linutronix.de>
References: <20070430102837.748238000@linutronix.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 10:43:31 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Andrew,
> 
> please pick up the following updates to clocksource / clockevents:
> 
> - Fixups to the resume logic
> - Keep TSC stable, when lapic_timer_c2_ok is set
> 

Should we be targetting these at 2.6.20.x?

