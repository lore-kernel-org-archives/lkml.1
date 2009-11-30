Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZK3BNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZK3BNL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 20:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZK3BNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 20:13:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46264
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbZK3BNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 20:13:09 -0500
Date: Sun, 29 Nov 2009 17:13:15 -0800 (PST)
Message-Id: <20091129.171315.78513393.davem@davemloft.net>
To: jkosina@suse.cz
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, andre.goddard@gmail.com,
       bruce.w.allan@intel.com
Subject: Re: linux-next: manual merge of the trivial tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LSU.2.00.0911241011520.6953@wotan.suse.de>
References: <20091124171459.88cb0c0d.sfr@canb.auug.org.au>
	<alpine.LSU.2.00.0911241011520.6953@wotan.suse.de>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Tue, 24 Nov 2009 10:13:47 +0100 (CET)

> Subject: e1000e: fix assorted typos
> 
> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

I'm happy to add this, but:

1) it doesn't apply to net-next-2.6

2) all networking patches should be CC:'d to netdev@vger.kernel.org
   particularly so that they get tracked in patchwork and therefore
   are much less likely to get lost

