Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbZBLBre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbZBLBre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbZBLBrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:47:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:51829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561AbZBLBrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:47:23 -0500
Date: Thu, 12 Feb 2009 02:47:18 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #12604] Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
Message-ID: <20090212014718.GF30043@wotan.suse.de>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.gUG.420jJB@chimera> <20090210162830.GD12146@placka.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210162830.GD12146@placka.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 05:28:30PM +0100, Jan Kara wrote:
> On Sun 08-02-09 20:21:42, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
>   Yes, I've verified with latest git and the regression is still there.

I'm working on this FWIW...

> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12604
> > Subject		: Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
> > Submitter	: Jan Kara <jack@suse.cz>
> > Date		: 2009-01-30 1:23 (10 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=31a12666d8f0c22235297e1c1575f82061480029
> > References	: http://marc.info/?l=linux-kernel&m=123327862901800&w=4
> 
> 									Honza
