Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbXHSF2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbXHSF2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 01:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbXHSF22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 01:28:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35655
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbXHSF22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 01:28:28 -0400
Date: Sat, 18 Aug 2007 22:28:27 -0700 (PDT)
Message-Id: <20070818.222827.40574674.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: torvalds@linux-foundation.org, shemminger@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] missing return in bridge sysfs code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070819035126.GS21089@ftp.linux.org.uk>
References: <20070819035126.GS21089@ftp.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 19 Aug 2007 04:51:26 +0100

> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks for catching this Al.
