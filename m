Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZBRBlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZBRBlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZBRBju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:39:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47210
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756146AbZBRBjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:39:48 -0500
Date: Tue, 17 Feb 2009 17:39:32 -0800 (PST)
Message-Id: <20090217.173932.176817674.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: hannes@hanneseder.net, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/43] drivers/net/sfc: fix sparse warning: symbol
 shadows an earlier one
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090216003820.GO15266@solarflare.com>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214213932.24377.94262.stgit@vmbox.hanneseder.net>
	<20090216003820.GO15266@solarflare.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Mon, 16 Feb 2009 00:38:20 +0000

> Hannes Eder wrote:
> > Impact: Move variable declaration as close to their usage as possible.
> > 
> > Fix this sparse warning:
> >   drivers/net/sfc/tenxpress.c:589:22: warning: symbol 'link_ok' shadows an earlier one
> >   drivers/net/sfc/tenxpress.c:575:30: originally declared here
> > 
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Ben Hutchings <bhutchings@solarflare.com>

Applied.
