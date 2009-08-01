Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZHAPvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZHAPvP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 11:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZHAPvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 11:51:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36860 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZHAPvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 11:51:14 -0400
Date: Sat, 1 Aug 2009 11:51:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jim Paradis <jparadis@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Dirty Page Tracking & on-the-fly memory mirroring
Message-ID: <20090801155112.GA10888@infradead.org>
References: <4A7390F6.6080207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7390F6.6080207@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Where is the actual consumer of this?  You add a lot of infrastructure
but no actualy code using it.  Working ar Red Hat should should more
than know that we don't add hooks for out of tree junk.  Or maybe you
should get a free bootcamp ticket from your manager..

Also your patch is extremly whitespace damaged, again quite sad for
someone working at a Linux company.

