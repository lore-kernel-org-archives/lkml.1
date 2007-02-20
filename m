Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbXBTJEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbXBTJEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 04:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932732AbXBTJEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 04:04:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50658
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932717AbXBTJEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 04:04:30 -0500
Date: Tue, 20 Feb 2007 01:04:27 -0800 (PST)
Message-Id: <20070220.010427.07640976.davem@davemloft.net>
To: bunk@stusta.de
Cc: akpm@osdl.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] remove the broken SUN_AURORA driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070220000703.GN13958@stusta.de>
References: <20070220000703.GN13958@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Tue, 20 Feb 2007 01:07:03 +0100

> The SUN_AURORA driver:
> - has been marked as BROKEN for more than two years and
> - is still marked as BROKEN.
> 
> Drivers that had been marked as BROKEN for such a long time seem to be
> unlikely to be revived in the forseeable future.
> 
> But if anyone wants to ever revive this driver, the code is still
> present in the older kernel releases.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Applied, thanks Adrian.
