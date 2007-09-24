Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbXIXRti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbXIXRti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbXIXRt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:49:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48212 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbXIXRt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:49:28 -0400
Date: Mon, 24 Sep 2007 18:49:24 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 5/7] Linux Kernel Markers - Use instrumentation kconfig menu
Message-ID: <20070924174924.GC1608@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	"Frank Ch. Eigler" <fche@redhat.com>, Adrian Bunk <bunk@stusta.de>
References: <20070924164950.006047409@polymtl.ca> <20070924165428.009275376@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924165428.009275376@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject and description sounds rather odd for just wiring up Kconfig
and Makefile.  I'd suggest merging this into the previous patch.
In fact given how small markers are it might make sense to put the
documentation into it aswell, it's probably still a lot below 400k.

