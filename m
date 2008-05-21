Return-Path: <linux-kernel-owner+w=401wt.eu-S934305AbYEUMLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305AbYEUMLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762314AbYEUMLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:11:09 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:36296 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759590AbYEUMLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:11:08 -0400
Date: Wed, 21 May 2008 08:09:39 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard
	indentation of arguments)
Message-ID: <20080521120939.GF8581@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
	davem@davemloft.net
References: <12113495282137-git-send-email-kongjianjun@gmail.com> <20080521083413.GM28946@ZenIV.linux.org.uk> <20080521015037.add0b78e.akpm@linux-foundation.org> <20080521103206.GA24545@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521103206.GA24545@infradead.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 06:32:06AM -0400, Christoph Hellwig wrote:
> On Wed, May 21, 2008 at 01:50:37AM -0700, Andrew Morton wrote:
> > Oh, what a marvellous way to encourage new contributors that was. Thank
> > you so much.
> > 
> > For the record: Al speaks only for himself and a lack of expressed
> > disagrement from others should not be taken as agreement.
> 
> But I'd like to second the opinion.  This is getting a little too far.
> We should rather try to at least enforce very basic standards a lot of
> the crap shoved in doesn't follow instead of wanking around about exact
> placement of whitespaces.

The real question is whether people who are wanking about whitespace
and spelling fixes in comments will graduate to writing real, useful
patches.  If they won't, there's no point to encouraging them.

						- Ted
