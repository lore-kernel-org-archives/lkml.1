Return-Path: <linux-kernel-owner+w=401wt.eu-S1759144AbXGBDg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144AbXGBDg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 23:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbXGBDgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 23:36:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34281
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756994AbXGBDgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 23:36:49 -0400
Date: Sun, 01 Jul 2007 20:37:09 -0700 (PDT)
Message-Id: <20070701.203709.120448384.davem@davemloft.net>
To: rpjday@mindspring.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SPARC64: Emphasize that sparc64 doesn't support return
 probes.
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0707011248490.3046@localhost.localdomain>
References: <Pine.LNX.4.64.0707011248490.3046@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Robert P. J. Day" <rpjday@mindspring.com>
Date: Sun, 1 Jul 2007 12:49:58 -0400 (EDT)

> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

I think it's simply better for me to add kretprobe
support don't you think?

It's on my todo list and I don't want to add this doc blurb
that will very shortly become wrong.
