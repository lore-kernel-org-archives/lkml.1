Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbYD3He6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbYD3He6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbYD3Het
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:34:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44281
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755211AbYD3Hes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:34:48 -0400
Date: Wed, 30 Apr 2008 00:34:47 -0700 (PDT)
Message-Id: <20080430.003447.200525841.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for April 30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080430173104.39897492.sfr@canb.auug.org.au>
References: <20080430173104.39897492.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 30 Apr 2008 17:31:04 +1000

> Also a build breakage in the v4l/dvb code - but this seems to have
> been caused by not cleaning my tree before the build.

No, I'm seeing allmodconfig builds fail even with a clean tree.  It's
from the recent v4l/dvb merge and I'm bisecting now.
