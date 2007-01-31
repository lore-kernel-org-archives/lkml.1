Return-Path: <linux-kernel-owner+w=401wt.eu-S1751841AbXAaEET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbXAaEET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 23:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXAaEET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 23:04:19 -0500
Received: from muan.mtu.ru ([195.34.34.229]:1712 "EHLO muan.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbXAaEET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 23:04:19 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: Free Linux Driver Development!
To: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Date: Wed, 31 Jan 2007 07:02:09 +0300
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org> <loom.20070130T231421-484@post.gmane.org> <45BFC9EF.4060506@garzik.org>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20070131040212.6057239B568@muan.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

>> When we switch to PATA and drop old ide stack, what will happen ?
>> Will all driver be ported and full-feature, or some will be obsoleted ?
> 
> All drivers for which we can find users will be ported.  If any features
> disappear that's a bug.
> 

Well, I have a long standing issue with pata_ali not detecting CD-ROM in DMA
mode. When I rarely watch DVD I rather boot into legacy IDE kernel ...

-andrey

