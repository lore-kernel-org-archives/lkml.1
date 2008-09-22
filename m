Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYIVSLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYIVSLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYIVSLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:11:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60502 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbYIVSLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:11:31 -0400
Date: Mon, 22 Sep 2008 14:11:48 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, prarit@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH] NMI watchdog: when booting with reset_devices, clear
	the performance counters
Message-ID: <20080922181148.GL16840@redhat.com>
References: <20080922171408.GJ16840@redhat.com> <20080922174748.GC10535@elte.hu> <20080922175803.GK16840@redhat.com> <20080922175924.GH10535@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922175924.GH10535@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > applied to tip/x86/nmi-watchdog, thanks.
> > > 
> > > i'm wondering, is this fix a v2.6.27 candidate?
> > I believe so. Even being a small affected group (P4 based boxes using NMI
> > watchdog and kdump), it's fully reproducible.
> 
> is there a bugzilla.kernel.org entry for it? If not, could you please 
> file it? Thanks,
#11621 created

-- 
Aristeu

