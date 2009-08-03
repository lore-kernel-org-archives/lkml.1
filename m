Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbZHCM1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbZHCM1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZHCM1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:27:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719AbZHCM1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:27:07 -0400
Date: Mon, 3 Aug 2009 14:27:05 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] Quota fix for 2.6.31-rc4
Message-ID: <20090803122704.GC21712@duck.suse.cz>
References: <20090730154009.GD28556@duck.suse.cz> <20090730215847.GC15780@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090730215847.GC15780@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 30-07-09 17:58:47, Christoph Hellwig wrote:
> On Thu, Jul 30, 2009 at 05:40:09PM +0200, Jan Kara wrote:
> >   Hello Linus,
> > 
> >   could you please pull from
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-quota-2.6.git for_linus
> > 
> >   to get:
> > 
> > Jan Kara (1):
> >       quota: Silence lockdep on quota_on
> 
> That's a very bad subject.  IF it's really just silencing it with
> annotations please write add lockdep annotations.  But this looks more
> like a real (even if mostly theoretical) deadlock, so the subject should
> mention that.
  Good point. Thanks. Will try to give a better subject next time.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
