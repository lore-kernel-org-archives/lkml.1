Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbXGKRWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbXGKRWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXGKRWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:22:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42061 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbXGKRWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:22:04 -0400
Date: Wed, 11 Jul 2007 10:21:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: -mm merge plans for 2.6.23
Message-Id: <20070711102103.c85ca324.akpm@linux-foundation.org>
In-Reply-To: <1184153982.17833.92.camel@pmac.infradead.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070711113553.GA18665@lst.de>
	<1184153982.17833.92.camel@pmac.infradead.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 12:39:42 +0100 David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2007-07-11 at 13:35 +0200, Christoph Hellwig wrote:
> > On Tue, Jul 10, 2007 at 01:31:52AM -0700, Andrew Morton wrote:
> > > romfs-printk-format-warnings.patch
> > 
> > NACK on this one. 
> 
> The rest of it is nacked anyway, until we unify the point and
> get_unmapped_area methods of the MTD API.
> 

Methinks you meant
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch, not
romfs-printk-format-warnings.patch.

I'll drop nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch, thamks.
