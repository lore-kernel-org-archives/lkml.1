Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbXKMMdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbXKMMdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXKMMdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:33:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35359
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbXKMMc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:32:59 -0500
Date: Tue, 13 Nov 2007 04:32:58 -0800 (PST)
Message-Id: <20071113.043258.222942202.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: kaber@trash.net, joonwpark81@gmail.com, w@1wt.eu, cfriesen@nortel.com,
       auke-jan.h.kok@intel.com, netdev@vger.kernel.org,
       djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when
 promiscuous mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071113121647.GA1330@gondor.apana.org.au>
References: <20071113120328.GB1086@gondor.apana.org.au>
	<20071113.040624.43544149.davem@davemloft.net>
	<20071113121647.GA1330@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 13 Nov 2007 20:16:47 +0800

> Perhaps those who want to push this patch should be encouraged
> to convert e1000 to the new interface :)

That is my feeling as well :-)
