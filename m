Return-Path: <linux-kernel-owner+w=401wt.eu-S935638AbXKPXfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935638AbXKPXfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761028AbXKPXf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:35:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34448 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957AbXKPXf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:35:28 -0500
Subject: Re: Linux 2.6.23.2
From: David Woodhouse <dwmw2@infradead.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Matti Aarnio <matti.aarnio@zmailer.org>, Mark Lord <lkml@rtr.ca>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20071116195745.GC17536@waste.org>
References: <20071116183752.GA9807@kroah.com>
	 <20071116183940.GC9807@kroah.com> <473DF101.3010501@rtr.ca>
	 <20071116193958.GJ6372@mea-ext.zmailer.org>
	 <20071116195745.GC17536@waste.org>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 18:35:30 -0500
Message-Id: <1195256130.2533.156.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-16 at 13:57 -0600, Matt Mackall wrote:
> What is the proper encoding for a patch that contains hunks in
> multiple character sets?

That should only happen when we're fixing legacy crap to become UTF-8 --
and in that case, it's probably best to just handle it with a git-pull
rather than mailing patches around.

Normally, we should see only UTF-8 in patches.

-- 
dwmw2

