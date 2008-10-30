Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYJ3Pud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYJ3Pud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYJ3Pu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:50:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35162 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbYJ3PuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:50:25 -0400
Date: Thu, 30 Oct 2008 11:51:21 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] nmi_watchdog: update procfs nmi_watchdog file
	documentation
Message-ID: <20081030155120.GP771@redhat.com>
References: <20081030151712.GO771@redhat.com> <20081030154534.GA19888@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030154534.GA19888@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Aristeu,
> 
> by reading this patch I found that maybe it's time to start
> using nmi_watchdog=[lapic,ioapic] instead of 1 and 2? We could make
> them as alases to existing numbers. Thoughts?
Yes, that would be useful.

-- 
Aristeu

