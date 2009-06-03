Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZFCKd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZFCKd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 06:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZFCKdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 06:33:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44006
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256AbZFCKdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 06:33:51 -0400
Date: Wed, 03 Jun 2009 03:33:51 -0700 (PDT)
Message-Id: <20090603.033351.193935428.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       eswierk@aristanetworks.com, aabdulla@nvidia.com
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090603122048.f2b7fef2.sfr@canb.auug.org.au>
References: <20090603122048.f2b7fef2.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 3 Jun 2009 12:20:48 +1000

> Hi Dave,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/forcedeth.c between commit
> 5a9a8e32ebe269c71d8d3e78f9435fe7729f38e9 ("forcedeth: add phy_power_down
> parameter, leave phy powered up by default (v2)") from Linus' tree and
> commit 88d7d8b00cdc3117150faab4c4ace6d464b71c22 ("forcedeth: add clock
> gating feature <resend>") from the net tree.
> 
> Just context changing.  I fixed it up (see below) and can carry the fix
> for a while.

This will be fixed with a push I'll do in a few moments.

Thanks Stephen!
