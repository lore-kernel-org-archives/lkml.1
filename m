Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYKCJck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYKCJck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYKCJcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:32:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45052 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbYKCJca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:32:30 -0500
Date: Mon, 3 Nov 2008 04:32:28 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Chinner <dgc@sgi.com>, Tiago Maluta <maluta_tiago@yahoo.com.br>
Subject: Re: [Bug #11805] mounting XFS produces a segfault
Message-ID: <20081103093228.GA3485@infradead.org>
References: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera> <4xS1r6m15_B.A.m8.KveDJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4xS1r6m15_B.A.m8.KveDJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 05:49:36PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).

The patch is in the XFS development tree.  Given that the maintainers
didn't manage to get it into the merge window it might make sense to
submit this fix individually.  Dave, what do you think about sending
this patch out directly to Linus?

