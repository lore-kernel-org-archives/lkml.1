Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZIWOHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZIWOHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZIWOHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:07:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35423 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZIWOHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:07:34 -0400
Date: Wed, 23 Sep 2009 10:07:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] introduce TRACE_EVENT_ABI (was Re: TRACE_EVENT_ABI ?)
Message-ID: <20090923140735.GA8504@infradead.org>
References: <20090923124340.GA6093@infradead.org> <1253714632.4498.3.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253714632.4498.3.camel@frodo>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 10:03:52AM -0400, Steven Rostedt wrote:
> I had this discussion with people in Portland. We seem to agree that
> this should just lock the old fields in, but you can add new ones at the
> end.

Please document this very clearly.

