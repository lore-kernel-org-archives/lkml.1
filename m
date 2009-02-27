Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbZB0HJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbZB0HJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbZB0HJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:09:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53474
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753451AbZB0HJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:09:07 -0500
Date: Thu, 26 Feb 2009 23:08:51 -0800 (PST)
Message-Id: <20090226.230851.130005232.davem@davemloft.net>
To: yjwei@cn.fujitsu.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: remove some pointless conditionals before
 kfree_skb()
From: David Miller <davem@davemloft.net>
In-Reply-To: <49A51CD9.4060408@cn.fujitsu.com>
References: <49A51CD9.4060408@cn.fujitsu.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 25 Feb 2009 18:26:33 +0800

> Remove some pointless conditionals before kfree_skb().
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied.
