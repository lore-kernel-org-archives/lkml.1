Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYKTJoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYKTJoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYKTJoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:44:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44584
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbYKTJoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:44:20 -0500
Date: Thu, 20 Nov 2008 01:44:20 -0800 (PST)
Message-Id: <20081120.014420.256210031.davem@davemloft.net>
To: jcliburn@gmail.com
Cc: alan-jenkins@tuffmail.co.uk, atl1-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, csnook@redhat.com
Subject: Re: atl2: don't mess up irq on suspend/resume (probably msi only)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081119183443.7ca1cf23@osprey.hogchain.net>
References: <4922FD09.2070007@tuffmail.co.uk>
	<49231CCB.8010900@tuffmail.co.uk>
	<20081119183443.7ca1cf23@osprey.hogchain.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jcliburn@gmail.com>
Date: Wed, 19 Nov 2008 18:34:43 -0600

> Can someone tell before I submit this patch if the description is sane?
> 
> atl2: don't request irq on resume if netif running

It looks good, mind if I just apply this as-is?

Thanks.
