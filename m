Return-Path: <linux-kernel-owner+w=401wt.eu-S932232AbXIOAhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbXIOAhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 20:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759470AbXIOAhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 20:37:21 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:48766
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbXIOAhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 20:37:20 -0400
Date: Fri, 14 Sep 2007 17:37:15 -0700 (PDT)
Message-Id: <20070914.173715.70208381.davem@davemloft.net>
To: billfink@mindspring.com
Cc: jpiszcz@lucidpixels.com, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org, apiszcz@solarrain.com
Subject: Re: In search of 10gbps cards/shootout in Linux?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070910000250.1a529e33.billfink@mindspring.com>
References: <Pine.LNX.4.64.0709081241100.22467@p34.internal.lan>
	<20070910000250.1a529e33.billfink@mindspring.com>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Fink <billfink@mindspring.com>
Date: Mon, 10 Sep 2007 00:02:50 -0400

> I haven't done any comparisons with other vendor offerings, but I can
> highly recommend the Myricom PCI-Express (8x) 10-GigE NICs.  They only
> cost about $900 and can do full unidirectional 10-GigE line rate.  And
> as a 10-GigE router, they can do full bidirectional 10-GigE line rate
> IP forwarding.  Note the choice of system/motherboard/CPU is as
> important as the choice of NIC in achieving maximum performance.

The only thing I don't like about the myri10ge cards is that
they lack VLAN offloading in hardware.

Strangely this appears to be common amongst 10gb parts :-/
