Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZETXET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZETXET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbZETXEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:04:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60473 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZETXEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:04:12 -0400
Date: Wed, 20 May 2009 19:04:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/3] tracing: add __print_flags for events
Message-ID: <20090520230413.GA11456@infradead.org>
References: <20090515210342.488025506@goodmis.org> <20090515210717.745370400@goodmis.org> <20090518173854.GA30425@infradead.org> <alpine.DEB.2.00.0905201810300.1080@gandalf.stny.rr.com> <20090520225921.GA15167@infradead.org> <alpine.DEB.2.00.0905201902060.1080@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905201902060.1080@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 07:02:56PM -0400, Steven Rostedt wrote:
> You mean more like a "__print_enumerated"? A backward translation of 
> enumerated types to their names.

Yeah.

> Perhaps __print_symbolic is a bit nicer name.

Sounds good.

