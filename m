Return-Path: <linux-kernel-owner+w=401wt.eu-S1763853AbYDXSx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763853AbYDXSx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760275AbYDXSxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:53:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbYDXSxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:53:11 -0400
Date: Thu, 24 Apr 2008 14:53:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [patch 10/15] m68k: Some network drivers do not check the
	platform
Message-ID: <20080424185309.GA22381@infradead.org>
References: <20080424182940.424312704@mail.of.borg> <20080424183242.943446357@mail.of.borg> <20080424184256.GA8531@infradead.org> <Pine.LNX.4.64.0804242045510.21224@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804242045510.21224@anakin>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 08:51:17PM +0200, Geert Uytterhoeven wrote:
> I suppose you mean platform_*device*_register(), not
> platform_*driver*_register()?

Yes, sorry.

---end quoted text---
