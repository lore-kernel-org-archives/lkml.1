Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbXEAO3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbXEAO3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbXEAO3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:29:06 -0400
Received: from pat.uio.no ([129.240.10.15]:52733 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbXEAO3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:29:01 -0400
Subject: Re: nfsd/md patches Re: 2.6.22 -mm merge plans
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20070501101502.GA27868@infradead.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <17974.34116.479061.912980@notabene.brown>
	 <20070501090843.GB17949@infradead.org>
	 <17975.3531.838077.563475@notabene.brown>
	 <20070501101502.GA27868@infradead.org>
Content-Type: text/plain
Date: Tue, 01 May 2007 07:34:14 -0700
Message-Id: <1178030054.5444.5.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: E4912DDB3C71C57DF63F98D548029E9034C69FAC
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 209 total 1435077 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 11:15 +0100, Christoph Hellwig wrote:
> On Tue, May 01, 2007 at 07:52:11PM +1000, Neil Brown wrote:
> > On Tuesday May 1, hch@infradead.org wrote:
> > > apropos nfsd patches, what's the merge plans for my two export ops
> > > patch series?
> > 
> > Still sitting in my tree - I've had my mind on other things
> > (nfs-utils, portmap....) and let them slip - sorry.
> > 
> > I think also there was an unanswered question about the second series
> > (there first I am completely happy with).
> 
> A sorry, this mail got somewhere lost.  I'll reply on the nfs list
> because we have a little more context there. (and due to the subscribers
> only policy I can't crosspost unfortunately)

I though we lifted the subscribers only policy quite a while back. There
should be nothing preventing you from cross-posting.

Cheers
  Trond

