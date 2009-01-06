Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZAFXUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZAFXUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbZAFXUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:20:02 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50754 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbZAFXUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:20:00 -0500
Date: Tue, 6 Jan 2009 18:19:58 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Warren Turkal <wt@penguintechs.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Diego Elio 'Flameeyes' Petten?" <flameeyes@gmail.com>
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090106231958.GA30271@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151747.c640dfd4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106151747.c640dfd4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 03:17:47PM -0800, Andrew Morton wrote:
> > I'm pretty sure we already had a version better than that in your
> > tree on the list.  But I've lost track and we should just restart
> > the review cycle on -fsdevel.
> 
> Yeah, I have the three hfs patches:
> 
> hfsplus-identify-journal-info-block-in-volume-header.patch
> hfsplus-fix-journal-detection.patch
> hfs-add-basic-export-support.patch
> 
> in a holding pattern awaiting a second round, due to laggy, incomplete
> and confusing noises from various people.  It all needs a revisit.

The first two are not for me to decide.  They look fine code-wise,
but IIRC Roman had some issues with wether the condition should be
possible at all.

The third one is where I requested a respin, and I'm pretty sure I've
seen a version with some improvement over the one in your tree.  Let's
get the latests version back on -fsdevel and review it again.

The one in your tree certainly is not ready.
