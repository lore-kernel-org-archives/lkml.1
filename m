Return-Path: <linux-kernel-owner+w=401wt.eu-S1761798AbXJDVGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761798AbXJDVGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758138AbXJDVF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:05:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40739
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757796AbXJDVF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:05:56 -0400
Date: Thu, 04 Oct 2007 14:05:55 -0700 (PDT)
Message-Id: <20071004.140555.85689371.davem@davemloft.net>
To: matthew@wil.cx
Cc: arjan@infradead.org, clameter@sgi.com, willy@linux.intel.com,
       nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dgc@sgi.com, jens.axboe@oracle.com
Subject: Re: SLUB performance regression vs SLAB
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071004205812.GQ12049@parisc-linux.org>
References: <20071004105046.7b019fe8@laptopd505.fenrus.org>
	<20071004.134834.112622292.davem@davemloft.net>
	<20071004205812.GQ12049@parisc-linux.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Date: Thu, 4 Oct 2007 14:58:12 -0600

> On Thu, Oct 04, 2007 at 01:48:34PM -0700, David Miller wrote:
> > There comes a point where it is the reporter's responsibility to help
> > the developer come up with a publishable test case the developer can
> > use to work on fixing the problem and help ensure it stays fixed.
> 
> That's a lot of effort.  Is it more effort than doing some remote
> debugging with Christoph?  I don't know.

That's a good question and an excellent point.  I'm sure that,
either way, Christoph will be more than willing to engage and
assist.
