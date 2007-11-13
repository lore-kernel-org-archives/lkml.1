Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbXKMLS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbXKMLS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXKMLSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:18:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752967AbXKMLSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:18:50 -0500
Date: Tue, 13 Nov 2007 03:18:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: "SL Baur" <steve@xemacs.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if
 !CONFIG_BINFMT_AOUT [try #5]
Message-Id: <20071113031835.54d558f9.akpm@linux-foundation.org>
In-Reply-To: <18662.1194951451@redhat.com>
References: <ed10ee420711121909y3e0f84d0hd07c331a9a0aba66@mail.gmail.com>
	<20071110181416.31dc2614.akpm@linux-foundation.org>
	<20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	<20071109153437.20803.55096.stgit@warthog.procyon.org.uk>
	<6214.1194881680@redhat.com>
	<20071112115353.227f35cb.akpm@linux-foundation.org>
	<ed10ee420711121450m5aec7c06vf4481ebad944d706@mail.gmail.com>
	<17306.1194909291@redhat.com>
	<18662.1194951451@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 10:57:31 +0000 David Howells <dhowells@redhat.com> wrote:

> SL Baur <steve@xemacs.org> wrote:
> 
> > Please take the emacsism out of the file as it bothers Andrew and others.
> 
> I thought Andrew said it didn't bother him.  I assume he was curious.
> 

Well it's just one line - hardly a big deal.

However if that line was a good one then we should get organised and
annotate all Kbuild files in the tree and appoint you
kbuild-makefile-tag-maintainer.

And if it wasn't a good line then it shouldn't have been added.
