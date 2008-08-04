Return-Path: <linux-kernel-owner+w=401wt.eu-S1764744AbYHDVDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764744AbYHDVDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764240AbYHDVCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:02:23 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3344 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763631AbYHDVCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:02:21 -0400
Date: Mon, 4 Aug 2008 16:45:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-04
Message-ID: <20080804204558.GA5866@tuxdriver.com>
References: <20080804193753.GA30345@tuxdriver.com> <1217882288.7819.19.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217882288.7819.19.camel@californication>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 10:38:08PM +0200, Marcel Holtmann wrote:
> Hi John,
> 
> > Luis R. Rodriguez (4):
> >       list.h: Add list_splice_tail() and list_splice_tail_init()
> >       list.h: add list_cut_position()
> 
> have these two changes got reviewed on LKML? I don't see any ACKs for it
> in the commit message.

Hmmm...no.  I thought the original patches had been copied to
linux-kernel, but it looks like that is not the case.

The original patches are archived here:

	http://marc.info/?l=linux-wireless&m=121783421908441&w=2

	http://marc.info/?l=linux-wireless&m=121783422008445&w=2

What problems do you see with them?

John
-- 
John W. Linville
linville@tuxdriver.com
