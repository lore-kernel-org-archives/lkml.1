Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZBRBmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZBRBmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbZBRBkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:40:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47221
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756229AbZBRBki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:40:38 -0500
Date: Tue, 17 Feb 2009 17:40:22 -0800 (PST)
Message-Id: <20090217.174022.33045548.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 29/43] drivers/net/tokenring: fix warning: format not a
 string literal and no ...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214214327.24377.33907.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214214327.24377.33907.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:44:19 +0100

> Impact: Use 'static const char[]' instead of 'static char[]'.
> 
> Fix this warnings:
>   drivers/net/tokenring/smctr.c:3644: warning: format not a string literal and no format arguments
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
