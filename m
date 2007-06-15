Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbXFOWQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbXFOWQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbXFOWQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:16:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34121
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755601AbXFOWQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:16:22 -0400
Date: Fri, 15 Jun 2007 15:16:40 -0700 (PDT)
Message-Id: <20070615.151640.99201246.davem@davemloft.net>
To: bunk@stusta.de
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] net/rxrpc/ar-output.c: remove dead code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070615214520.GM3588@stusta.de>
References: <20070615214520.GM3588@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Fri, 15 Jun 2007 23:45:20 +0200

> This patch removes dead code spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

I'll let David H. decide how to handle these cleanups
and simplifications.  Thanks Adrian.
