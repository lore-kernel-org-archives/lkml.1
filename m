Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZBJRJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZBJRJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZBJRI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:08:57 -0500
Received: from ns1.suse.de ([195.135.220.2]:33560 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZBJRI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:08:56 -0500
Date: Tue, 10 Feb 2009 17:28:30 +0100
From: Jan Kara <jack@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [Bug #12604] Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
Message-ID: <20090210162830.GD12146@placka.suse.cz>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.gUG.420jJB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sWhNs83kKPE.A.gUG.420jJB@chimera>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 08-02-09 20:21:42, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
  Yes, I've verified with latest git and the regression is still there.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12604
> Subject		: Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
> Submitter	: Jan Kara <jack@suse.cz>
> Date		: 2009-01-30 1:23 (10 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=31a12666d8f0c22235297e1c1575f82061480029
> References	: http://marc.info/?l=linux-kernel&m=123327862901800&w=4

									Honza
