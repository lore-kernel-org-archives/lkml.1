Return-Path: <linux-kernel-owner+w=401wt.eu-S1761068AbZCPUg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068AbZCPUg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 16:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759277AbZCPUgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 16:36:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54587
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756878AbZCPUgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 16:36:14 -0400
Date: Mon, 16 Mar 2009 13:35:59 -0700 (PDT)
Message-Id: <20090316.133559.173588446.davem@davemloft.net>
To: jesper@krogh.cc
Cc: fubar@us.ibm.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@redhat.com, aowi@novozymes.com
Subject: Re: Regression in bonding between 2.6.26.8 and 2.6.27.6 - bisected
 - twice
From: David Miller <davem@davemloft.net>
In-Reply-To: <49BEB7DE.9000201@krogh.cc>
References: <20090313.161217.52045656.davem@davemloft.net>
	<8799.1236986836@death.nxdomain.ibm.com>
	<49BEB7DE.9000201@krogh.cc>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Krogh <jesper@krogh.cc>
Date: Mon, 16 Mar 2009 21:34:38 +0100

> Jay Vosburgh wrote:
> > 	The above fragment isn't needed for mainline, only for -stable.
> > 
> 
> Did you sent it off to the stable kernel maintainers?

The fix has to go into Linus's tree first.

I haven't integrated Jay's changes yet.
