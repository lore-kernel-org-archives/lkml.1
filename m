Return-Path: <linux-kernel-owner+w=401wt.eu-S1161024AbXBMFJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161024AbXBMFJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 00:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161025AbXBMFJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 00:09:47 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:42892 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161023AbXBMFJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 00:09:46 -0500
Date: Tue, 13 Feb 2007 08:08:04 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, David Miller <davem@davemloft.net>,
       netdev <netdev@vger.kernel.org>, Zach Brown <zach.brown@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Chase Venters <chase.venters@clientec.com>,
       Johann Borck <johann.borck@densedata.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Jamal Hadi Salim <hadi@cyberus.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org
Subject: Re: [take35 0/10] kevent: Generic event handling mechanism.
Message-ID: <20070213050804.GA1859@2ka.mipt.ru>
References: <asdasdqaa0591036@2ka.mipt.ru> <11703247503374@2ka.mipt.ru> <20070205142336.GA24190@2ka.mipt.ru> <20070212103510.GC5703@2ka.mipt.ru> <45D080C5.4000500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45D080C5.4000500@redhat.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Tue, 13 Feb 2007 08:08:23 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 06:59:17AM -0800, Ulrich Drepper (drepper@redhat.com) wrote:
> Evgeniy Polyakov wrote:
> > I think that mean that everybody is happy with APi, design and set of
> > features. 
> 
> No comment means that I still have not been able to test anything since
> regardless of what version I tried, it failed to build.

I think if you would provide error message you saw, I fixed that in a
couple of moments, doesn't it?

I will send new patchset next week when rc1 will be out and your
feedback is greatly appreciated.

> -- 
> ➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
> 



-- 
	Evgeniy Polyakov
