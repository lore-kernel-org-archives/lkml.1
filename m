Return-Path: <linux-kernel-owner+w=401wt.eu-S1766813AbXEBTop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766813AbXEBTop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766791AbXEBTop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:44:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37206 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766813AbXEBToo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:44:44 -0400
Date: Wed, 2 May 2007 20:44:42 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] firewire: add it all to kbuild
Message-ID: <20070502194442.GE1248@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux1394-devel <linux1394-devel@lists.sourceforge.net>
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <tkrat.c82a1d775d989371@s5r6.in-berlin.de> <tkrat.abd13e310a4516c7@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.abd13e310a4516c7@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +fw-core-objs := fw-card.o fw-topology.o fw-transaction.o fw-iso.o \
> +	fw-device.o fw-cdev.o

fw-core-y += ..

