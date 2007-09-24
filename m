Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbXIXTH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbXIXTH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758249AbXIXTHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:07:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45801 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011AbXIXTHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:07:12 -0400
Date: Mon, 24 Sep 2007 20:07:08 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] Linux Kernel Markers (redux)
Message-ID: <20070924190708.GA6262@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070924164950.006047409@polymtl.ca> <20070924181148.GA3285@infradead.org> <20070924190452.GE28347@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924190452.GE28347@Krystal>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 03:04:52PM -0400, Mathieu Desnoyers wrote:
> I provided blktrace as a first user of the markers, but I agree that it
> may be a little late for merging. I can keep it for later too.

I we manage to get Dave's trace patches and your markers in I'll make
sure to get a sputrace version using them in as a demo for both.

