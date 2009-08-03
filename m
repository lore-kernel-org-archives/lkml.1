Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZHCDTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZHCDTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 23:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZHCDTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 23:19:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59798
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbZHCDTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 23:19:11 -0400
Date: Sun, 02 Aug 2009 20:19:19 -0700 (PDT)
Message-Id: <20090802.201919.153551298.davem@davemloft.net>
To: jaswinder@kernel.org
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE: ide-taskfile.c fix compilation warning and cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1246094308.2961.15.camel@hpdv5.satnam>
References: <1245986290.3568.1.camel@hpdv5.satnam>
	<200906262142.43102.bzolnier@gmail.com>
	<1246094308.2961.15.camel@hpdv5.satnam>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date: Sat, 27 Jun 2009 14:48:28 +0530

> Hello Bart, David,
> 
> On Fri, 2009-06-26 at 21:42 +0200, Bartlomiej Zolnierkiewicz wrote:
>> On Friday 26 June 2009 05:18:10 Jaswinder Singh Rajput wrote:
>> > On Mon, 2009-06-22 at 12:50 +0200, Bartlomiej Zolnierkiewicz wrote:
>> 
>> > > Besides I would suggest splitting the patch on fix and cleanup parts.
>> > 
>> > Here is the cleanup part:
>> > 
>> > [PATCH] IDE: ide-taskfile.c fix style problems
 ...
>> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
>> 
>> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Thanks.

Applied to ide-next-2.6

> If you want I can also fix another ide files.
> 
> David, is it OK.

Just don't go overboard as IDE is in deep maintainence mode.
