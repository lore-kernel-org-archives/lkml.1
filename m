Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZBPHlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZBPHlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZBPHkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:40:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58337
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755778AbZBPHkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:40:24 -0500
Date: Sun, 15 Feb 2009 23:40:07 -0800 (PST)
Message-Id: <20090215.234007.25283952.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH v2] drivers/isdn/hardware/mISDN: change type of
 hfc_jiffies to unsigned long
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214230701.21991.75646.stgit@vmbox.hanneseder.net>
References: <20090214230701.21991.75646.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sun, 15 Feb 2009 00:10:33 +0100

> Jiffies are unsigned long, make sure we fit in jiffies store variable
> on archs with bits per long > 32.
> 
> Patch suggested by Jiri Slaby.
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Also applied, thank you.
