Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZBRB3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZBRB3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbZBRB1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:27:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49803
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756177AbZBRB1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:27:43 -0500
Date: Tue, 17 Feb 2009 17:27:27 -0800 (PST)
Message-Id: <20090217.172727.80119726.davem@davemloft.net>
To: divy@chelsio.com
Cc: hannes@hanneseder.net, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/43] drivers/net/cxgb3: fix sparse warnings: fix
 signedness
From: David Miller <davem@davemloft.net>
In-Reply-To: <499889D7.2070305@chelsio.com>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214211612.23489.60993.stgit@vmbox.hanneseder.net>
	<499889D7.2070305@chelsio.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Sun, 15 Feb 2009 13:32:07 -0800

> Hannes Eder wrote:
> > Fix this sparse warning:
> >   drivers/net/cxgb3/ael1002.c:1010:60: warning: incorrect type in argument 4 (different signedness)
> >
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> >   
> Acked-by: Divy Le Ray <divy@chelsio.com>

Applied.
