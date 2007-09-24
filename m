Return-Path: <linux-kernel-owner+w=401wt.eu-S1761836AbXIXSbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761836AbXIXSbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbXIXSay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:30:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58166 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbXIXSax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:30:53 -0400
Date: Mon, 24 Sep 2007 19:30:42 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
Message-ID: <20070924183042.GA4418@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	"Frank Ch. Eigler" <fche@redhat.com>
References: <20070924164950.006047409@polymtl.ca> <20070924165428.335030720@polymtl.ca> <20070924175044.GD1608@infradead.org> <20070924105632.009aba7f.randy.dunlap@oracle.com> <20070924180041.GB2435@infradead.org> <20070924111318.f16cde07.randy.dunlap@oracle.com> <20070924181931.GA3810@infradead.org> <46F800A7.7090005@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F800A7.7090005@oracle.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 11:23:35AM -0700, Randy Dunlap wrote:
> That might be OK for this case, but sometimes it makes sense to have
> README etc. about how to use the software.  So you would want this
> in the Documentation/ tree?  That makes it harder on users.

If it's so complex that we can't describe it in a few dozens lines
it shouldn't be anywhere but the place it belongs and better have a
real use and not just be a sample.  And in the trace case I must
admit that I'd prefer a real use like some simple syscall-trace
over this hack anyway..

