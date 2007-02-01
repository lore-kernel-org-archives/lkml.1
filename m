Return-Path: <linux-kernel-owner+w=401wt.eu-S1422987AbXBAUY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422987AbXBAUY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422989AbXBAUY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:24:56 -0500
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:44593 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422987AbXBAUYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:24:54 -0500
Date: Thu, 1 Feb 2007 21:24:41 +0100
From: Mattia Dongili <malattia@linux.it>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070201202440.GA3025@inferi.kami.home>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	mingo@redhat.com
References: <20070129204528.eb8d695e.akpm@osdl.org> <20070131215241.GB2890@inferi.kami.home> <20070131232130.GC4137@inferi.kami.home> <1170358572.29240.292.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170358572.29240.292.camel@localhost.localdomain>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.20-rc6-mm3-2 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 08:36:12PM +0100, Thomas Gleixner wrote:
> On Thu, 2007-02-01 at 00:21 +0100, Mattia Dongili wrote: 
> > yes, slowness is gone. Any useful information I can provide?
> 
> Can you please try with CONFIG_ACPI_PROCESSOR=y instead of =m ? This
> should make the slowness go away too.

not much luck. Actually the general slowness is gone but at netfilter
registration the the boot almost stops.

I'll provide the info you requested shortly.
-- 
mattia
:wq!
