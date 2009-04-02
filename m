Return-Path: <linux-kernel-owner+w=401wt.eu-S1764302AbZDBXc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764302AbZDBXc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761381AbZDBXcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:32:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54620
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759575AbZDBXck convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:32:40 -0400
Date: Thu, 02 Apr 2009 16:32:28 -0700 (PDT)
Message-Id: <20090402.163228.261255942.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: markus@trippelsdorf.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, uwe.bugla@gmx.de
Subject: Re: [PATCH 1/2] tcp: add helper for counter tweaking due mid-wq
 change
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0904021212310.30150@wrl-59.cs.helsinki.fi>
References: <20090331184959.GA2725@gentoox2.trippelsdorf.de>
	<Pine.LNX.4.64.0904011352470.30150@wrl-59.cs.helsinki.fi>
	<Pine.LNX.4.64.0904021212310.30150@wrl-59.cs.helsinki.fi>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 2 Apr 2009 12:15:17 +0300 (EEST)

> [PATCH 1/2] tcp: add helper for counter tweaking due mid-wq change
> 
> We need full-scale adjustment to fix a TCP miscount in the next
> patch, so just move it into a helper and call for that from the
> other places.
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

Applied.
