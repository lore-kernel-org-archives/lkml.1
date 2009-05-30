Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbZE3IFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbZE3IFl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 04:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZE3IFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 04:05:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59663 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZE3IFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 04:05:14 -0400
Date: Sat, 30 May 2009 04:05:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v8 0/7] tracing: kprobe-based event tracer and x86
	instruction decoder
Message-ID: <20090530080503.GA15755@infradead.org>
References: <20090529000326.17532.70868.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529000326.17532.70868.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small question to start with: What's your (or Hitachi s/Red Hat's) use case
for this?  It's obviously really cool technology, but I fear without
some good user space side to make it easy to use it will most likely
bit-rot which would be sad.

