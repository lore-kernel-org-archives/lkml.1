Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbYGQXN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbYGQXN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933170AbYGQXNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:13:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:33066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933157AbYGQXNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:13:32 -0400
Date: Thu, 17 Jul 2008 16:08:57 -0700
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <htejun@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 12/15] driver core: Implement tagged directory support
	for device classes.
Message-ID: <20080717230857.GB28377@suse.de>
References: <m1vdzmh2jr.fsf_-_@frodo.ebiederm.org> <m1r6aah2hh.fsf_-_@frodo.ebiederm.org> <m1mykyh2fu.fsf_-_@frodo.ebiederm.org> <m1hcb6h2d2.fsf_-_@frodo.ebiederm.org> <486DD650.3000804@gmail.com> <m1tzf593ny.fsf@frodo.ebiederm.org> <486E2C3B.6020603@gmail.com> <20080704161200.GA1440@suse.de> <m1lk052ptp.fsf@frodo.ebiederm.org> <487D6A24.9070001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D6A24.9070001@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 12:25:24PM +0900, Tejun Heo wrote:
> Eric W. Biederman wrote:
> > Greg KH <gregkh@suse.de> writes:
> >> Sorry, Greg is walking out the door in 30 minutes for a much needed week
> >> long vacation and can't look into this right now :(
> >>
> >> I'll be able to review it next weekend, sorry for the delay.
> > 
> > Any progress in reviewing these changes, and seeing if you can stand
> > to merge them?
> 
> Greg, please disregard my earlier NACKs and commit the patches if you're
> okay with them.  I'm working on cleaning it up but I don't think I'll be
> able to make it in time for merge window and as Eric said getting the
> functionality in place is more important at this point as it doesn't
> affect user visible interface.

Ok, I'll work to get these in where applicable.

thanks,

greg k-h
