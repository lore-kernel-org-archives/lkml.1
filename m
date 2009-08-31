Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZHaStT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZHaStT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZHaStS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:49:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZHaStR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:49:17 -0400
Date: Mon, 31 Aug 2009 14:49:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tim Walberg <twalberg@comcast.net>, Christoph Hellwig <hch@infradead.org>,
       Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs compat_ioctl?
Message-ID: <20090831184918.GB10393@infradead.org>
References: <4A9B759B.7020401@msgid.tls.msk.ru> <20090831123010.GA2368@infradead.org> <20090831183751.GC19343@comcast.net> <20090831184822.GA10393@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831184822.GA10393@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 02:48:22PM -0400, Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 01:37:51PM -0500, Tim Walberg wrote:
> > Linux sparcy 2.6.30.4-sparcy #2 Sat Aug 1 21:14:46 CDT 2009 sparc64 GNU/Linux
> > sparcy:~# file $(which xfs_fsr)
> > /usr/sbin/xfs_fsr: ELF 32-bit MSB executable, SPARC32PLUS, V8+ Required, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18, stripped
> 
> I'll take a look at that, thanks.

Err, sorry - is that with the patch I posted in this thread or without?

