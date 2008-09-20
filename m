Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbYITUTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbYITUTj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 16:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYITUT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 16:19:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37018
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbYITUT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 16:19:28 -0400
Date: Sat, 20 Sep 2008 13:19:15 -0700 (PDT)
Message-Id: <20080920.131915.143583562.davem@davemloft.net>
To: dwalker@mvista.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com, steffen.klassert@secunet.com
Subject: Re: [PATCH 2/2]: softirq: Add support for triggering softirq work
 on softirqs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1221941809.1343.229.camel@localhost.localdomain>
References: <1221925413.1343.132.camel@localhost.localdomain>
	<20080920.130325.56429707.davem@davemloft.net>
	<1221941809.1343.229.camel@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@mvista.com>
Date: Sat, 20 Sep 2008 13:16:49 -0700

> On Sat, 2008-09-20 at 13:03 -0700, David Miller wrote:
> 
> > On UP we get a single queue, which the layer needs anyways.
> > It just always queues to the one queue.
> > 
> > Unlike Andrew's, your review comments have been completely and utterly
> > useless, as well as a total waste of my time.
> 
> If you don't want your code reviewed, _don't send it_

Sounds like a plan.

