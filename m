Return-Path: <linux-kernel-owner+w=401wt.eu-S965383AbXBLUuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965383AbXBLUuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965366AbXBLUuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:50:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43266
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965318AbXBLUuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:50:08 -0500
Date: Mon, 12 Feb 2007 12:50:07 -0800 (PST)
Message-Id: <20070212.125007.115911168.davem@davemloft.net>
To: latten@austin.ibm.com
Cc: ce@ruault.com, herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org
Subject: Re: [BUG] 2.6.20 Oopses in xfrm_audit_log
From: David Miller <davem@davemloft.net>
In-Reply-To: <200702121744.l1CHiUD2026684@faith.austin.ibm.com>
References: <200702121744.l1CHiUD2026684@faith.austin.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joy Latten <latten@austin.ibm.com>
Date: Mon, 12 Feb 2007 11:44:30 -0600

> This is similar to another bug reported last month.
> Here is the patch I sent out then. Please let me know
> how it goes.
> 
> Regards,
> Joy
> 
> Signed-off-by: Joy Latten <latten@austin.ibm.com>

This one is my bad, I should have gotten around to properly
reviewing this patch before 2.6.20-final went out.  I'll
up the priority on this one to make sure it gets into -stable
and mainline soon.

Thanks for resending Joy.
