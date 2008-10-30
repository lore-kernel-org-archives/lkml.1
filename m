Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbYJ3RKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbYJ3RKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757917AbYJ3RJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:09:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900AbYJ3RJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:09:45 -0400
Date: Thu, 30 Oct 2008 13:10:53 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC -tip] x86: nmi - add sensible names to nmi_watchdog boot
	param
Message-ID: <20081030171052.GR771@redhat.com>
References: <20081030161646.GC19888@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030161646.GC19888@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add sensible names as "lapic" and "ioapic" to
> nmi_watchdog boot parameter. Sometimes it is not
> that easy to recall what exactly nmi_watchdog=1
> does mean so we allow the using of symbolic names here.
> 
> Old numeric values remain valid.
looks good to me, but you need to update the documentation as well.

-- 
Aristeu

