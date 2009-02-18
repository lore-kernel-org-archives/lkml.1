Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbZBRBjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbZBRBjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbZBRBiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:38:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47194
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754785AbZBRBit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:38:49 -0500
Date: Tue, 17 Feb 2009 17:38:33 -0800 (PST)
Message-Id: <20090217.173833.35304295.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/43] drivers/net/hamradio: fix sparse warning: symbol
 shadows an earlier one
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214213505.24377.11448.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214213505.24377.11448.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:35:35 +0100

> Impact: Rename inner scrope variable.
> 
> Fix this sparse warning:
>   drivers/net/hamradio/yam.c:856:35: warning: symbol 'dev' shadows an earlier one
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
