Return-Path: <linux-kernel-owner+w=401wt.eu-S1763644AbXGKLkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763644AbXGKLkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761231AbXGKLkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:40:00 -0400
Received: from verein.lst.de ([213.95.11.210]:54006 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163AbXGKLkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:40:00 -0400
Date: Wed, 11 Jul 2007 13:39:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: buffered write patches, -mm merge plans for 2.6.23
Message-ID: <20070711113944.GC18665@lst.de>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  pagefault-in-write deadlock fixes.  Will hold for 2.6.24.

Why that?  This stuff has been in forever and is needed at various
levels.  We need this in for anything to move forward on the buffered
write front.

