Return-Path: <linux-kernel-owner+w=401wt.eu-S933451AbZJNOQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451AbZJNOQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933411AbZJNOQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:16:38 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51764 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933380AbZJNOQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:16:37 -0400
Date: Wed, 14 Oct 2009 09:14:38 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/4 v2] X86: UV RTC fixes/cleanup
Message-ID: <20091014141438.GA11048@sgi.com>
References: <20091009134727.GB3218@sgi.com> <20091012162317.GC1272@elte.hu> <20091012175233.GA8129@sgi.com> <20091012175920.GB17138@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012175920.GB17138@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches provide fixes and cleanup to SGI UV RTC
clocksource/clockevents code.

Subject: [PATCH 1/4 v2] X86: UV RTC fix early expiry handling
Subject: [PATCH 2/4 v2] X86: UV RTC add clocksource only boot option
Subject: [PATCH 3/4 v2] X86: UV RTC cleanup error handling
Subject: [PATCH 4/4 v2] X86: UV RTC rename generic_interrupt

