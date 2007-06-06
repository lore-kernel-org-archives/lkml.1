Return-Path: <linux-kernel-owner+w=401wt.eu-S1765554AbXFFPum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765554AbXFFPum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760857AbXFFPue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:50:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45751 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbXFFPud (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:50:33 -0400
Date: Wed, 6 Jun 2007 16:50:21 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Richard Griffiths <richard.griffiths@windriver.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       carsteno@de.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070606155021.GA19503@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Richard Griffiths <richard.griffiths@windriver.com>,
	Jared Hulbert <jaredeh@gmail.com>, carsteno@de.ibm.com,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux-kernel@vger.kernel.org
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <1181143064.4194.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181143064.4194.4.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 08:17:43AM -0700, Richard Griffiths wrote:
> Too late :) The XIP cramfs patch is widely used in the embedded Linux
> community and has been used for years. It fulfills a need for a small
> XIP Flash file system. Hence our interest in getting it or some
> variation into the mainline kernel.

That's not a reason to put it in as-is.  Maybe you should have showed
up here before making the wrong decision to hack this into cramfs.
