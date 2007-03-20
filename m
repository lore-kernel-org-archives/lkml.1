Return-Path: <linux-kernel-owner+w=401wt.eu-S1030777AbXCTADs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030777AbXCTADs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030776AbXCTADs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:03:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51415
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030773AbXCTADr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:03:47 -0400
Date: Mon, 19 Mar 2007 17:03:47 -0700 (PDT)
Message-Id: <20070319.170347.126762285.davem@davemloft.net>
To: bunk@stusta.de
Cc: andrew.hendry@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x25_forward_call(): fix NULL dereferences
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070319092403.GK752@stusta.de>
References: <20070319092403.GK752@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Mon, 19 Mar 2007 10:24:03 +0100

> This patch fixes two NULL dereferences spotted by the Coverity checker.
> 
> For a better understanding, the "diff -uwp" output (that ignores the 
> indentation changes) is:

I'll apply this, thanks Adrian.
