Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbXL3DAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbXL3DAL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 22:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbXL3C74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 21:59:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35904
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752160AbXL3C7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 21:59:55 -0500
Date: Sat, 29 Dec 2007 18:59:48 -0800 (PST)
Message-Id: <20071229.185948.13302114.davem@davemloft.net>
To: tsbogend@alpha.franken.de
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, horms@verge.net.au
Subject: Re: [PATCH] Fix broken ip= parsing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071229170849.C2E68C2EEE@solo.franken.de>
References: <20071229170849.C2E68C2EEE@solo.franken.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date: Sat, 29 Dec 2007 18:08:49 +0100 (CET)

> Commit a6c05c3d064dbb83be88cba3189beb5db9d2dfc3 breaks ip= parsing
> completly, because ic_enable is never set. The patch below puts
> back the way ic_enable was set before.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

I already have this exact patch in my net-2.6 tree from Simon.
Thanks.
