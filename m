Return-Path: <linux-kernel-owner+w=401wt.eu-S1751706AbZGSWBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbZGSWBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 18:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZGSWBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 18:01:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41387 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751321AbZGSWBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 18:01:39 -0400
Date: Sun, 19 Jul 2009 23:01:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Athanasius <link@miggy.org>, Julien TINNES <jt@cr0.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@ubuntu.com>,
       Eugene Teo <eugene@redhat.com>
Subject: Re: [link@miggy.org: Re: [patch 2/8] personality: fix
 PER_CLEAR_ON_SETID (CVE-2009-1895)]
Message-ID: <20090719230113.4a4885cf@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907191219230.13838@localhost.localdomain>
References: <20090718202512.GA19587@suse.de>
	<alpine.LFD.2.01.0907181342500.13838@localhost.localdomain>
	<20090718212812.GI6722@miggy.org>
	<4A6278FD.20807@cr0.org>
	<20090719122701.GJ6722@miggy.org>
	<alpine.LFD.2.01.0907191219230.13838@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These days? We could probably get rid of that idiotic feature. It's simply 
> not important enough any more. Does anybody really care? At the same time, 
> over years we've grown _other_ personality flags, and some of them are 
> still relevant.

If it bugs you enough then a sysfs flag of "personality flags to honour"
is pretty trivial.

Alan
