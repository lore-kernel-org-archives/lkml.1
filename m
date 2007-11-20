Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbXKTIMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbXKTIMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 03:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbXKTIMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 03:12:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43057 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbXKTIMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:12:36 -0500
Date: Tue, 20 Nov 2007 08:12:30 +0000
From: Christoph Hellwig <hch@infradead.org>
To: clameter@sgi.com
Cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 18/45] cpu alloc: XFS counters
Message-ID: <20071120081230.GA1324@infradead.org>
References: <20071120011132.143632442@sgi.com> <20071120011335.975705216@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120011335.975705216@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 05:11:50PM -0800, clameter@sgi.com wrote:
> Also remove the useless zeroing after allocation. Allocpercpu already
> zeroed the objects.

You still haven't answered my comment to the last iteration.
