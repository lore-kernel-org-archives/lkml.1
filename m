Return-Path: <linux-kernel-owner+w=401wt.eu-S932425AbZEASbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbZEASbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 14:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932211AbZEASaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 14:30:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42153 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760933AbZEASav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 14:30:51 -0400
Date: Fri, 1 May 2009 14:30:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Tridgell <tridge@samba.org>, Steve French <sfrench@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090501183050.GA16600@infradead.org>
References: <1241199689.13073.6.camel@norville.austin.ibm.com> <20090501174757.GC8104@infradead.org> <1241201562.13073.30.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241201562.13073.30.camel@norville.austin.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 01:12:42PM -0500, Dave Kleikamp wrote:
> Some linux-based devices would be happy not to contain code to create
> the long name at all.

Then patch it out.

