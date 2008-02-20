Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYBTDbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYBTDbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYBTDau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:30:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47294
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751195AbYBTDat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:30:49 -0500
Date: Tue, 19 Feb 2008 19:31:25 -0800 (PST)
Message-Id: <20080219.193125.04536962.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2][POWERPC] Fix initial lmb add region with a non-zero
 base
From: David Miller <davem@davemloft.net>
In-Reply-To: <4130F47E-4F4A-4911-B63B-403A8C423565@kernel.crashing.org>
References: <Pine.LNX.4.64.0802191350590.10089@blarg.am.freescale.net>
	<20080219.163003.152862383.davem@davemloft.net>
	<4130F47E-4F4A-4911-B63B-403A8C423565@kernel.crashing.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Tue, 19 Feb 2008 21:02:04 -0600

> np.  Are we trying to get this into 2.6.25 or .26?

I'm ambivalent but I would obviously prefer 2.6.25 because
it would allow me to proceed more easily with my sparc64
NUMA work as well as get your bug fixes in more smoothly.
