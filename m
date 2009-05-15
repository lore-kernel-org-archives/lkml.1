Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZEOQvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZEOQvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZEOQu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:50:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZEOQu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:50:56 -0400
Date: Fri, 15 May 2009 12:50:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ferenc Wagner <wferi@niif.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Ray Lee <ray-lk@madrabbit.org>,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, Anton Salikhmetov <salikhmetov@gmail.com>
Subject: Re: mmap vs mtime in 2.6.26 and up
Message-ID: <20090515165054.GA11439@infradead.org>
References: <874ovws94s.fsf@tac.ki.iif.hu> <87ljp2v6vt.fsf@tac.ki.iif.hu> <2c0942db0905120837g702b457bm52a412293925021a@mail.gmail.com> <20090512155301.GA23160@infradead.org> <87ws8i720y.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ws8i720y.fsf@tac.ki.iif.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 06:40:29PM +0200, Ferenc Wagner wrote:
> Thanks for the analysis.  Unfortunately I don't nearly know enough to
> work on this issue, but would like to track it as it affects our
> backup system.  So, shouldn't #2645 be reopened again?

Yes, definitively as the current "fix" is incorrected.  I'll try to cook
up a correct version once I get some time.

