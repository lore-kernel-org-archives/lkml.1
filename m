Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbXJ3R77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbXJ3R77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbXJ3R7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:59:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41716 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852AbXJ3R7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:59:43 -0400
Date: Tue, 30 Oct 2007 17:58:43 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create kinst/ or ki/ directory ?
Message-ID: <20071030175843.GA18916@infradead.org>
References: <20071029215138.GA4233@Krystal> <20071029154741.cb093f55.rdunlap@xenotime.net> <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal> <472667F3.3000505@garzik.org> <20071030172442.GA4477@Krystal> <alpine.LFD.0.999.0710301044110.30120@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710301044110.30120@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think "instrumentation" was/is a particularly bad thing to group things 
> by. It doesn't actually tell you anything about the thing, and it's not 
> even true that some people are interested in "instrumentation"  and others 
> aren't. 

I completely agree.  This is not the kind of thing we need to categorize.

