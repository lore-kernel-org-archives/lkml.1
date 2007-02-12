Return-Path: <linux-kernel-owner+w=401wt.eu-S965019AbXBLRSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019AbXBLRSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965014AbXBLRSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:18:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34108 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964961AbXBLRSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 12:18:00 -0500
Date: Mon, 12 Feb 2007 09:13:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: davem@davemloft.net, drepper@redhat.com, netdev@vger.kernel.org,
       zach.brown@oracle.com, hch@infradead.org, chase.venters@clientec.com,
       johann.borck@densedata.com, linux-kernel@vger.kernel.org,
       jeff@garzik.org, hadi@cyberus.ca, mingo@elte.hu,
       linux-fsdevel@vger.kernel.org
Subject: Re: [take35 0/10] kevent: Generic event handling mechanism.
Message-Id: <20070212091335.9c00d5d9.akpm@linux-foundation.org>
In-Reply-To: <20070212103510.GC5703@2ka.mipt.ru>
References: <asdasdqaa0591036@2ka.mipt.ru>
	<11703247503374@2ka.mipt.ru>
	<20070205142336.GA24190@2ka.mipt.ru>
	<20070212103510.GC5703@2ka.mipt.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 12 Feb 2007 13:35:10 +0300 Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> Andrew, do you consider kevent for inclusion or declining?

I haven't had time to think about it in the past month or two, sorry.

However we might as well get it back in there for review-and-test - please
send a new patchset once 2.6.21-rc1 is released and copy me on it?
