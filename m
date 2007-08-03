Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbXHCI2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbXHCI2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 04:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXHCI14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 04:27:56 -0400
Received: from smtp.aaisp.net.uk ([81.187.81.52]:43352 "EHLO smtp.aaisp.net.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbXHCI1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 04:27:55 -0400
Date: Fri, 3 Aug 2007 09:27:52 +0100
From: Andrew Clayton <andrew@digital-domain.net>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Subject: Re: [NFSD OOPS] 2.6.23-rc1-git10
Message-ID: <20070803092752.51e74f8c@zeus.pccl.info>
In-Reply-To: <18098.42691.783443.554197@notabene.brown>
References: <20070802171450.7c9b4af3@zeus.pccl.info>
	<18098.42691.783443.554197@notabene.brown>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007 13:53:39 +1000, Neil Brown wrote:

[snip]

> So clearly we need some proper locking around thread start-up and
> shutdown.  We had previous relied on lock_kernel, but that isn't
> really good enough for this.   I'll try to figure out the best way to
> fix it.  Meanwhile, I doubt the problem will recur.
> 
> Thanks for the report.

Thanks for the explanation!

> NeilBrown

Andrew
