Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYGCX5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYGCX5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 19:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYGCX5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 19:57:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:37508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbYGCX5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 19:57:33 -0400
Date: Thu, 3 Jul 2008 16:51:41 -0700
From: Greg KH <gregkh@suse.de>
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25.10
Message-ID: <20080703235141.GA21549@suse.de>
References: <555236.75770.qm@web52912.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555236.75770.qm@web52912.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 04:42:01PM -0700, Chris Rankin wrote:
> > Again, if the above information is somehow insufficient as to what
> > exactly is fixed in the -stable releases, and anyone has questions about
> > how these release announcements are created, please let me know.
> 
> Well, for example:
> 
> I have only machines with 32 bit CPUS, none of them is hot-pluggable

All cpus these days can be "virtually" hotplugged :)

> and none has an i915 graphics chip. All my local users are "trusted",
> nor am I running any multi-threaded Java applications on SMP systems.
> (I also have no idea what ICM pages are, but they sound jolly
> impressive!)
> 
> And what is "native_read_tscp" all about?

Ask the developer who did that.

> So why am I being "STRONGLY encouraged to upgrade to this release"?
> (Your emphasis.) Is it because otherwise you're going to sneak up and
> burn my house down?

Fixing an ABI breakage that you could hit might be a good thing for you
to have, as well as the other general fixes.

If you can read the changelog and see that you feel you can skip this
release, fine.  Otherwise, please upgrade.

thanks,

greg k-h
