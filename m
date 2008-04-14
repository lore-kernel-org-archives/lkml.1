Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYDNL63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYDNL63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 07:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbYDNL6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 07:58:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51763 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbYDNL6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 07:58:09 -0400
Date: Mon, 14 Apr 2008 07:57:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>, dwmw2@infradead.org, hch@infradead.org,
       akpm@linux-foundation.org, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080414115740.GA29059@infradead.org>
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu> <20080414094215.GD2076@shareable.org> <E1JlLRt-0005JD-QR@pomaz-ex.szeredi.hu> <20080414115540.GA5802@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414115540.GA5802@shareable.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 12:55:40PM +0100, Jamie Lokier wrote:
> It's not really a joke.  It really is a problem: I'm supposed to
> provide NTFS support for a project, but the kernel I'm using doesn't
> work with FUSE (too old for the FUSE version needed by ntfs-3g), and
> the in-kernel NTFS isn't good enough - all the active development work
> is done on ntfs-3g.

It's getting a little offtopic, but what keeps you from backporting
the required fuse version?

