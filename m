Return-Path: <linux-kernel-owner+w=401wt.eu-S1765487AbXGKR0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765487AbXGKR0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbXGKR0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:26:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14549 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbXGKR0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:26:21 -0400
Date: Wed, 11 Jul 2007 10:28:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: -mm merge plans for 2.6.23
Message-Id: <20070711102853.4267493f.randy.dunlap@oracle.com>
In-Reply-To: <20070711102103.c85ca324.akpm@linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070711113553.GA18665@lst.de>
	<1184153982.17833.92.camel@pmac.infradead.org>
	<20070711102103.c85ca324.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 10:21:03 -0700 Andrew Morton wrote:

> On Wed, 11 Jul 2007 12:39:42 +0100 David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Wed, 2007-07-11 at 13:35 +0200, Christoph Hellwig wrote:
> > > On Tue, Jul 10, 2007 at 01:31:52AM -0700, Andrew Morton wrote:
> > > > romfs-printk-format-warnings.patch
> > > 
> > > NACK on this one. 
> > 
> > The rest of it is nacked anyway, until we unify the point and
> > get_unmapped_area methods of the MTD API.
> > 
> 
> Methinks you meant
> nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch, not
> romfs-printk-format-warnings.patch.
> 
> I'll drop nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch, thamks.

Thanks.  I was certainly getting confused.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
