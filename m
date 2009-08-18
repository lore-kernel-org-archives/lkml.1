Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbZHRX3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbZHRX3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZHRX3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:29:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45925
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbZHRX3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:29:41 -0400
Date: Tue, 18 Aug 2009 16:29:52 -0700 (PDT)
Message-Id: <20090818.162952.161230185.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-08-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090818151436.GA2768@tuxdriver.com>
References: <20090818151436.GA2768@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 18 Aug 2009 11:14:37 -0400

> Dave,
> 
> Two more for 2.6.31...
> 
> The one from Johannes is actually already in net-next-2.6, but it has
> since been reported to cause a possible irq lock inversion dependency in
> 2.6.31-rc6, as described here:
> 
> 	http://marc.info/?l=linux-wireless&m=125052198303537&w=2
> 
> The one from me fixes a minor bounds checking problem in orinoco, as
> reported by Dan Carpenter.  It is simple and obvious.

Pulled, thanks John.
