Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbXA1Pgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbXA1Pgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbXA1Pgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:36:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45368 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXA1Pgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:36:38 -0500
Date: Sun, 28 Jan 2007 15:36:33 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] fs: break the file_list_lock for sb->s_files
Message-ID: <20070128153633.GA25223@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
	linux-kernel@vger.kernel.org
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120510.090289000@programming.kicks-ass.net> <20070128144358.GC16552@infradead.org> <20070128152106.GA9196@elte.hu> <20070128153006.GB23410@infradead.org> <1169998363.10987.30.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169998363.10987.30.camel@lappy>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 04:32:43PM +0100, Peter Zijlstra wrote:
> please see patch 2/7, its unrelated to lockdep internals.

I can't see any 2/7 on lkml yet..

