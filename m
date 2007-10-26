Return-Path: <linux-kernel-owner+w=401wt.eu-S1759221AbXJZK54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221AbXJZK54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbXJZK5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:57:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39704
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbXJZK5n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:57:43 -0400
Date: Fri, 26 Oct 2007 03:57:45 -0700 (PDT)
Message-Id: <20071026.035745.216735808.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: bunk@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [2.6 patch] make tcp_match_skb_to_sack() static
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0710242102530.11009@kivilampi-30.cs.helsinki.fi>
References: <20071024162358.GA30533@stusta.de>
	<Pine.LNX.4.64.0710242102530.11009@kivilampi-30.cs.helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 25 Oct 2007 00:39:23 +0300 (EEST)

> On Wed, 24 Oct 2007, Adrian Bunk wrote:
> 
> > tcp_match_skb_to_sack() can become static.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> [...snip...]
> 
> Thanks, I should have noticed that right from the beginning...

Yep, applied, thanks!
