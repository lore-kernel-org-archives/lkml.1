Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbXJAA5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbXJAA5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 20:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXJAA51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 20:57:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58673
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbXJAA50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 20:57:26 -0400
Date: Sun, 30 Sep 2007 17:57:26 -0700 (PDT)
Message-Id: <20070930.175726.48827024.davem@davemloft.net>
To: mchan@broadcom.com
Cc: vda.linux@googlemail.com, jeff@garzik.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
From: David Miller <davem@davemloft.net>
In-Reply-To: <1190429237.4957.6.camel@dell>
References: <200709211803.55554.vda.linux@googlemail.com>
	<20070921.104912.41646795.davem@davemloft.net>
	<1190429237.4957.6.camel@dell>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Fri, 21 Sep 2007 19:47:17 -0700

> On Fri, 2007-09-21 at 10:49 -0700, David Miller wrote:
> > From: Denys Vlasenko <vda.linux@googlemail.com>
> > Date: Fri, 21 Sep 2007 18:03:55 +0100
> > 
> > > Do patches look ok to you?
> > 
> > I'm travelling so I haven't looked closely yet :-)
> > 
> > Michael can take a look and I'll try to do so as well
> > tonight.
> > 
> 
> I've already reviewed the earlier versions of the patch and have made
> some suggestions.  This latest one looks ok to me and tested ok.
> 
> I'll follow up later with another patch to remove all the zeros in other
> firmware sections, and to remove the gzip headers completely.
> 
> Acked-by: Michael Chan <mchan@broadcom.com>

I've added these patches to net-2.6.24, thanks.
