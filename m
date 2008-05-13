Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbYEMJAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbYEMJAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758161AbYEMJAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:00:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37776 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415AbYEMJAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:00:10 -0400
Date: Tue, 13 May 2008 04:59:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
Message-ID: <20080513085959.GA23849@infradead.org>
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com> <1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com> <20080507002345.831bc379.akpm@linux-foundation.org> <20080507080027.GA23621@infradead.org> <482951D0.3070004@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482951D0.3070004@yandex.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 11:31:12AM +0300, Artem Bityutskiy wrote:
> Here is an updated UBIFS tarball for you:
> 	http://www.infradead.org/~dedekind/ubifs/ubifs-08-05-13.tar.bz2
>
> Did you have chance to do the reviw? We would like to ask for merge at
> 2.6.27.

Sorry, www.infradead.org was down during the weeked when I had some time
to review it.  I've grabbed a copy of the new tarball now and will look
at it soon.  Also I don't think it's too late for .26 as ubifs only adds
new code except the writeback_inodes_sb bit which should be trivial
enough for .26.

