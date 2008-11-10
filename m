Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYKJVzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYKJVzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYKJVzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:55:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35146
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbYKJVza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:55:30 -0500
Date: Mon, 10 Nov 2008 13:55:30 -0800 (PST)
Message-Id: <20081110.135530.55645015.davem@davemloft.net>
To: kay.sievers@vrfy.org
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: net: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1226057416.4100.18.camel@nga>
References: <1225329299.5970.67.camel@nga.site>
	<1226057416.4100.18.camel@nga>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 07 Nov 2008 12:30:16 +0100

> Updated patch, which does not replace BUS_ID_SIZE for now.
> 
> (BUS_ID_SIZE will go away from the driver core after the API switch, and
> it has to be replaced by a local definition in the network tree, or the
> limit can be removed entirely.)

Applied to net-next-2.6, thanks Kay.
