Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbYGJOdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbYGJOdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbYGJOdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:33:10 -0400
Received: from [194.117.236.238] ([194.117.236.238]:60588 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757985AbYGJOdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:33:09 -0400
Date: Thu, 10 Jul 2008 17:31:22 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: zhp <zhpsub@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Is there any way to download all email archive of linux kernel,
 and then import to Gmail for search?
Message-ID: <20080710173122.165849d4@linux360.ro>
In-Reply-To: <20080710062516.10342511.akpm@linux-foundation.org>
References: <337eb86f0807030721n1ab86217j2eb9a43d526ebf5f@mail.gmail.com>
	<20080710062516.10342511.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 06:25:16 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 3 Jul 2008 22:21:42 +0800 zhp <zhpsub@gmail.com> wrote:
> 
> > I have found that there is some methods for me to migrate local
> > existing emails to Gmail for search.
> > 
> > * Gmail Loader
> > see http://www.linux.com/articles/60733
> > 
> > * imapsync,
> > see http://freshmeat.net/projects/imapsync/
> > 
> > However, the problem is where can I get all of the old mails to my
> > local computer?
> > Has anyone done such things sucessfully?
> 
> http://userweb.kernel.org/~akpm/lkml-mbox-archives/ might be useful.
> 
> (Gad, 8MB/sec bandwidth from my Tokyo hotel room to kernel.org!)

I'm reading LKML via NNTP from Gmane (not Gmail). But Gmane also
provides mbox exporting, take a look at http://gmane.org/export.php

I suppose you could use one of these two methods (NNTP or their export
stuff) to download your old mails.


	Cheers,
	Eduard
