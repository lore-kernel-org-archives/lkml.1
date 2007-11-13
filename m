Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbXKMMrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbXKMMrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbXKMMq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:46:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37988 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbXKMMq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:46:58 -0500
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if
	!CONFIG_BINFMT_AOUT [try #5]
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, SL Baur <steve@xemacs.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
In-Reply-To: <20071113031835.54d558f9.akpm@linux-foundation.org>
References: <ed10ee420711121909y3e0f84d0hd07c331a9a0aba66@mail.gmail.com>
	 <20071110181416.31dc2614.akpm@linux-foundation.org>
	 <20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	 <20071109153437.20803.55096.stgit@warthog.procyon.org.uk>
	 <6214.1194881680@redhat.com>
	 <20071112115353.227f35cb.akpm@linux-foundation.org>
	 <ed10ee420711121450m5aec7c06vf4481ebad944d706@mail.gmail.com>
	 <17306.1194909291@redhat.com> <18662.1194951451@redhat.com>
	 <20071113031835.54d558f9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 13:46:46 +0100
Message-Id: <1194958006.8255.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-13 at 03:18 -0800, Andrew Morton wrote:
> On Tue, 13 Nov 2007 10:57:31 +0000 David Howells <dhowells@redhat.com> wrote:
> 
> > SL Baur <steve@xemacs.org> wrote:
> > 
> > > Please take the emacsism out of the file as it bothers Andrew and others.
> > 
> > I thought Andrew said it didn't bother him.  I assume he was curious.
> > 
> 
> Well it's just one line - hardly a big deal.
> 
> However if that line was a good one then we should get organised and
> annotate all Kbuild files in the tree and appoint you
> kbuild-makefile-tag-maintainer.
> 
> And if it wasn't a good line then it shouldn't have been added.

IFF we're going to annotate files like this, then also add the magic
incantation to make vim do the right thing :-)



