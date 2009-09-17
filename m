Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbZIQRsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbZIQRsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbZIQRsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:48:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50740
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757263AbZIQRsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:48:51 -0400
Date: Thu, 17 Sep 2009 10:49:08 -0700 (PDT)
Message-Id: <20090917.104908.42532152.davem@davemloft.net>
To: mingo@elte.hu
Cc: gorcunov@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [crash] kernel BUG at net/core/pktgen.c:3503!
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090917174448.GA9548@elte.hu>
References: <20090915185112.GA17587@lenovo>
	<20090917.102923.174779685.davem@davemloft.net>
	<20090917174448.GA9548@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 17 Sep 2009 19:44:48 +0200

> Anyway - please disregard this bugreport until i've investigated it 
> closer.

Ok, thanks for the status update.
