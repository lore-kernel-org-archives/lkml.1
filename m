Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZHGQBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZHGQBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZHGQBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:01:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58242
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753602AbZHGQBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:01:49 -0400
Date: Fri, 07 Aug 2009 09:01:58 -0700 (PDT)
Message-Id: <20090807.090158.45976865.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the
 IRQ context
From: David Miller <davem@davemloft.net>
In-Reply-To: <200908071355.21648.bzolnier@gmail.com>
References: <200907011835.27586.bzolnier@gmail.com>
	<20090701.134729.13610576.davem@davemloft.net>
	<200908071355.21648.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Fri, 7 Aug 2009 13:55:21 +0200

> On Wednesday 01 July 2009 22:47:29 David Miller wrote:
>> Will get to it before the end of the weekend.
>> 
>> If I fail or abort, I'll integrate your version of the fix Bart, don't
>> worry :)
> 
> Not that I'm worried but just out of curiosity..
> 
> Could you please tell me which week/month/year are we talking about here?

I became busier than I expected here in New York :-)

Actually both patches #4 and #5 are in my ide-next-2.6 tree, I just
need to publish it out to kernel.org and update the patchwork status
on these patches.
