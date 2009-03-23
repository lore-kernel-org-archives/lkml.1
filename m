Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbZCWWAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbZCWWAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 18:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbZCWWAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 18:00:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54266
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbZCWWAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 18:00:18 -0400
Date: Mon, 23 Mar 2009 15:00:05 -0700 (PDT)
Message-Id: <20090323.150005.113220590.davem@davemloft.net>
To: tilman@imap.cc
Cc: stable@kernel.org, kawk@users.sourceforge.net, hjlipp@web.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.27/28-stable] bas_gigaset: correctly allocate USB
 interrupt transfer buffer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090323-patch-01.tilman@imap.cc>
References: <20090323-patch-01.tilman@imap.cc>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Mon, 23 Mar 2009 22:47:06 +0100 (CET)

> the following patch backports the Gigaset driver bugfix merged for
> 2.6.29 as commit 170ebf85160dd128e1c4206cc197cce7d1424705 to both
> v2.6.27.x and v2.6.28.x. I would appreciate to see it included in
> your stable series.

If you ask me I can and will do it during my networking patch
-stable submission.
