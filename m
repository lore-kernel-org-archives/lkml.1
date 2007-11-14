Return-Path: <linux-kernel-owner+w=401wt.eu-S1763758AbXKNXvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763758AbXKNXvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbXKNXvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:51:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57114
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753584AbXKNXvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:51:12 -0500
Date: Wed, 14 Nov 2007 15:51:12 -0800 (PST)
Message-Id: <20071114.155112.34106808.davem@davemloft.net>
To: jochen@scram.de
Cc: linuxppc-embedded@ozlabs.org, marcelo@kvack.org, scottwood@freescale.com,
       linux-kernel@vger.kernel.org, jeff@garzik.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] powerpc: Fix fs_enet module build
From: David Miller <davem@davemloft.net>
In-Reply-To: <473AE325.8070901@scram.de>
References: <4739EDA8.6020800@scram.de>
	<20071113.210926.97725854.davem@davemloft.net>
	<473AE325.8070901@scram.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jochen Friedrich <jochen@scram.de>
Date: Wed, 14 Nov 2007 12:59:33 +0100

> I know it's ugly, however, module building is completely
> broken right now and I just want to provide a quick and
> ugly fix until both that ppc->powerpc transition and the
> new binding transition are over. Noone wants to touch the
> old stuff any more as it's a pita and it's already scheduled
> for removal in a couple of months.

Fair enough, I'll apply the patch.

Thanks for the explanation.
