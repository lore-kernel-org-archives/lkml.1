Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZBRB3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZBRB3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZBRB1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:27:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54469
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753026AbZBRB1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:27:31 -0500
Date: Tue, 17 Feb 2009 17:27:15 -0800 (PST)
Message-Id: <20090217.172715.248316017.davem@davemloft.net>
To: divy@chelsio.com
Cc: hannes@hanneseder.net, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/43] drivers/net/cxgb3: fix sparse warning: symbol
 shadows an earlier one
From: David Miller <davem@davemloft.net>
In-Reply-To: <4998897A.3030904@chelsio.com>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214211557.23489.75670.stgit@vmbox.hanneseder.net>
	<4998897A.3030904@chelsio.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Sun, 15 Feb 2009 13:30:34 -0800

> Hannes Eder wrote:
> > Impact: Move variable declaration as close to usage as possible.
> >
> > Fix this sparse warning:
> >   drivers/net/cxgb3/cxgb3_main.c:1586:21: warning: symbol 'cap' shadows an earlier one
> >
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> >   
> Acked-by: Divy Le Ray <divy@chelsio.com>

Applied.
