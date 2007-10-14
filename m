Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbXJNFXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbXJNFXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 01:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbXJNFXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 01:23:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51245
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752719AbXJNFXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 01:23:30 -0400
Date: Sat, 13 Oct 2007 22:23:32 -0700 (PDT)
Message-Id: <20071013.222332.74749961.davem@davemloft.net>
To: komurojun-mbn@nifty.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [NOT VERY SAFE] [TCP]: Set initial_ssthresh default to zero in
 Cubic and BIC.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071014135356.19754635.komurojun-mbn@nifty.com>
References: <20071014100245.914b784a.komurojun@nifty.com>
	<20071014132851.8d6a9de3.komurojun@nifty.com>
	<20071014135356.19754635.komurojun-mbn@nifty.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Komuro <komurojun-mbn@nifty.com>
Date: Sun, 14 Oct 2007 13:53:56 +0900

> Sorry, my mailer's mail-address setting is wrong.

Thank you for fixing this :-)
