Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZJYHv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZJYHv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 03:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbZJYHv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 03:51:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZJYHv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 03:51:58 -0400
Date: Sun, 25 Oct 2009 03:51:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Announce: Sysprof 1.1.2 CPU profiler for Linux
Message-ID: <20091025075157.GA3909@infradead.org>
References: <ye8bpkxemk0.fsf@camel21.daimi.au.dk> <20091006150751.GA28868@infradead.org> <20091012205812.GF17163@elte.hu> <ye8pr8r59x9.fsf@camel23.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ye8pr8r59x9.fsf@camel23.daimi.au.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 10:13:54PM +0200, Soeren Sandmann wrote:
> > > Is it time to deprectate the sysprof ftrace plugin?
> > 
> > Yes - but it's minimal maintenance overhead so we want to keep it for 
> > kernel release or two, to sunset it properly.
> 
> Makes sense to me.

Will either of you prepare an officially deprecation statement?

