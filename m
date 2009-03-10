Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbZCJVqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbZCJVqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756704AbZCJVpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:45:41 -0400
Received: from mail.suse.de ([195.135.220.2]:59992 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbZCJVpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:45:40 -0400
Date: Tue, 10 Mar 2009 22:45:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oliver Neukum <oneukum@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] two hiddev fixes [-rc regressions]
In-Reply-To: <20090309223726.565021009@cmpxchg.org>
Message-ID: <alpine.LNX.2.00.0903102245040.11733@jikos.suse.cz>
References: <20090309223726.565021009@cmpxchg.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Johannes Weiner wrote:

> here are two patches for hiddev bugs that were introduced past .28.  I
> think patch #2 fixes the 5th top bug on kerneloops.org for this
> release cycle.  More details in the changelogs.
> 
> Well, no kerneloops link, the site just keeps time-outing on me...
> It's the finish_wait() entry with 23 reports.

I have applied both patches, thanks a lot for fixing this, Hannes.

-- 
Jiri Kosina
SUSE Labs
