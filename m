Return-Path: <linux-kernel-owner+w=401wt.eu-S1161060AbXBMFQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161060AbXBMFQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 00:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161042AbXBMFQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 00:16:25 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38363 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161035AbXBMFQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 00:16:23 -0500
Date: Tue, 13 Feb 2007 08:14:54 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davem@davemloft.net, drepper@redhat.com, netdev@vger.kernel.org,
       zach.brown@oracle.com, hch@infradead.org, chase.venters@clientec.com,
       johann.borck@densedata.com, linux-kernel@vger.kernel.org,
       jeff@garzik.org, hadi@cyberus.ca, mingo@elte.hu,
       linux-fsdevel@vger.kernel.org
Subject: Re: [take35 0/10] kevent: Generic event handling mechanism.
Message-ID: <20070213051454.GB1859@2ka.mipt.ru>
References: <asdasdqaa0591036@2ka.mipt.ru> <11703247503374@2ka.mipt.ru> <20070205142336.GA24190@2ka.mipt.ru> <20070212103510.GC5703@2ka.mipt.ru> <20070212091335.9c00d5d9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070212091335.9c00d5d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Tue, 13 Feb 2007 08:14:59 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 09:13:35AM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> > On Mon, 12 Feb 2007 13:35:10 +0300 Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > Andrew, do you consider kevent for inclusion or declining?
> 
> I haven't had time to think about it in the past month or two, sorry.
> 
> However we might as well get it back in there for review-and-test - please
> send a new patchset once 2.6.21-rc1 is released and copy me on it?

Ok, I will.
You are always in copy for kevent patchsets.

-- 
	Evgeniy Polyakov
