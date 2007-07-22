Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbXGVC3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbXGVC3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 22:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXGVC3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 22:29:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52574
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbXGVC3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 22:29:05 -0400
Date: Sat, 21 Jul 2007 19:29:04 -0700 (PDT)
Message-Id: <20070721.192904.10298367.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com, johnpol@2ka.mipt.ru
Subject: Re: [RFC 1/1] lro: Generic Large Receive Offload for TCP traffic
From: David Miller <davem@davemloft.net>
In-Reply-To: <200707201741.49290.ossthema@de.ibm.com>
References: <200707201741.49290.ossthema@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Bernd Themann <ossthema@de.ibm.com>
Date: Fri, 20 Jul 2007 17:41:48 +0200

> Generic LRO patch
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

I have no general objections to this patch.

However I'd like to see at least one or two uses of these APIs before
we put it in, and it sounds as if we have at least two pending and
in the works if not ready already, so that shouldn't be an issue.

Thanks.
