Return-Path: <linux-kernel-owner+w=401wt.eu-S1765598AbXJRP0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765598AbXJRP0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765390AbXJRP0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:26:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51900 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765324AbXJRP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:26:04 -0400
Date: Thu, 18 Oct 2007 16:25:53 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/21] KGDB: Request to merge KGDB
Message-ID: <20071018152552.GA13985@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Wessel <jason.wessel@windriver.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
References: <4713B238.4030409@windriver.com> <20071017212025.d8a52694.akpm@linux-foundation.org> <20071018152310.GA7299@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018152310.GA7299@linux-sh.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 12:23:10AM +0900, Paul Mundt wrote:
> It would also be nice to balance this out with the utrace merge, as both
> are going to cause quite a lot of pain on the architecture side.

I don't think a utrace merge as in one big merge is going to happen ever.
It's just a too big patch doing too many things at once.  And the flag day
for switching all architectures over is another blocker.

