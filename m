Return-Path: <linux-kernel-owner+w=401wt.eu-S933277AbXGTHR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbXGTHR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbXGTHRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:17:51 -0400
Received: from verein.lst.de ([213.95.11.210]:48126 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759243AbXGTHRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:17:50 -0400
Date: Fri, 20 Jul 2007 09:17:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill DECLARE_MUTEX_LOCKED
Message-ID: <20070720071742.GB25717@lst.de>
References: <20070719211135.GA32725@lst.de> <a781481a0707192228r4c4e6bdfj53449d1fc67bc641@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0707192228r4c4e6bdfj53449d1fc67bc641@mail.gmail.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 10:58:34AM +0530, Satyam Sharma wrote:
> That comment in libusual is quite nonsensical, IMHO. Note that
> usu_init_notify is declared as DECLARE_MUTEX_LOCKED and yet the
> author wants us to believe (later, when he's doing that dummy

Given that no one should use libusual and we should kill it and the
abomination called ub I don't really care about fixing this up.

