Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbZAFXIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbZAFXIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZAFXIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:08:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923AbZAFXIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:08:42 -0500
Date: Tue, 6 Jan 2009 15:08:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       linux-arch@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090106150804.2697e0c2.akpm@linux-foundation.org>
In-Reply-To: <20090106225744.GA10553@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(suitable cc's added)

On Tue, 6 Jan 2009 17:57:44 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> > mm-invoke-oom-killer-from-page-fault.patch
> > mm-invoke-oom-killer-from-page-fault-fix.patch
> > mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
> 
> Just implementing this behaviour for x86 and uml is extremly
> counter-productive.  Please fix up all architectures as this
> behaviour needs to be the same on all ports (at least those
> with a MMU)

Yes, that would be nice.  
