Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbZKQONk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbZKQONk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZKQONk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:13:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57019
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494AbZKQONj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:13:39 -0500
Date: Tue, 17 Nov 2009 06:13:55 -0800 (PST)
Message-Id: <20091117.061355.205349414.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: khali@linux-fr.org, sfr@canb.auug.org.au, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       mika.kuoppala@nokia.com, linux-i2c@vger.kernel.org
Subject: Re: Shared i2c adapter locking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1258464774.2732.6.camel@achroite.uk.solarflarecom.com>
References: <20091117103554.03971b2f@hyperion.delvare>
	<20091117.035147.80164577.davem@davemloft.net>
	<1258464774.2732.6.camel@achroite.uk.solarflarecom.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Tue, 17 Nov 2009 13:32:54 +0000

> You will need to merge Linus's tree into net-next-2.6 and resolve the
> conflict by applying Jean's changes to drivers/net/sfc/falcon_boards.c.

Ok, I'll sort this out after I next push to Linus, thanks!
