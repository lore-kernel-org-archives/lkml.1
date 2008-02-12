Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbYBLQqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbYBLQqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764176AbYBLQoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:44:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764166AbYBLQoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:44:54 -0500
Date: Tue, 12 Feb 2008 11:44:52 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Christoph Hellwig <hch@infradead.org>,
       sam@ravnborg.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 0/8] Create and populate toplevel tests/ for kernel
	tests
Message-ID: <20080212164452.GA31096@infradead.org>
References: <20080211104452.GB7944@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211104452.GB7944@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 04:14:52PM +0530, Ananth N Mavinakayanahalli wrote:
> The following series of patches create and populate the toplevel tests/
> directory. This will henceforth be the place where all in-kernel tests
> live.
> 
> All patches against 2.6.25-rc1 and are just code movement without any
> change in functionality.

ACK to patches 1-7, and I agree with Ingo that the x86-specific test
should stay under arch/x86.

