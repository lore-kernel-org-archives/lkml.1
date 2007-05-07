Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbXEGG7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbXEGG7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 02:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXEGG7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 02:59:49 -0400
Received: from www.osadl.org ([213.239.205.134]:60945 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754078AbXEGG7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 02:59:48 -0400
Subject: Re: [patch 2/3] ACPI: Keep TSC stable, when lapic_timer_c2_ok is
	set
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070506234356.da324185.akpm@linux-foundation.org>
References: <20070430102837.748238000@linutronix.de>
	 <20070430102851.987296000@linutronix.de>
	 <20070506234356.da324185.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 07 May 2007 09:01:51 +0200
Message-Id: <1178521311.4550.0.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-06 at 23:43 -0700, Andrew Morton wrote:
> I'm now up to the third or fourth time where I need to try to repair this
> patch against churn in Len's tree.  I'm not sure what I'm doing and that
> changelog is of little help to me.
> 
> I think I'll drop it.  Please work it with Len.

Will do.

	tglx


