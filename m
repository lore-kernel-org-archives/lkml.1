Return-Path: <linux-kernel-owner+w=401wt.eu-S1032140AbXEHVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032140AbXEHVBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967789AbXEHVBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:01:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41603
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S967754AbXEHVB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:01:29 -0400
Date: Tue, 08 May 2007 14:01:29 -0700 (PDT)
Message-Id: <20070508.140129.08323329.davem@davemloft.net>
To: gene.heskett@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: gmail
From: David Miller <davem@davemloft.net>
In-Reply-To: <200705081035.04031.gene.heskett@gmail.com>
References: <200705081035.04031.gene.heskett@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gene Heskett <gene.heskett@gmail.com>
Date: Tue, 8 May 2007 10:35:03 -0400

> verizon forced me over to a gmail account by refusing this mailing list.
> Now lkml seems to be refusing posts from my gmail account.
> 
> Is there a reason?

I just forwarded to you a copy of a bounce so you can try
to figure out what's going wrong.

A "X-Mailing-List: " header line is showing up in your emails
and we block on that because it indicates a loop most of the
time.
