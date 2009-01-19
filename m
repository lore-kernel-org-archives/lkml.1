Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZASFaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZASFaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 00:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZASF3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 00:29:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60706
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbZASF3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 00:29:51 -0500
Date: Sun, 18 Jan 2009 21:29:52 -0800 (PST)
Message-Id: <20090118.212952.156342736.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, wenxiong@us.ibm.com
Subject: Re: [PATCH 2.6.30] cxgb3 - ease msi-x settings conditions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090118204836.10826.2994.stgit@speedy5>
References: <20090118204836.10826.2994.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Sun, 18 Jan 2009 12:48:36 -0800

> The driver currently drops to line interrupt mode
> if it did not get all the msi-x vectors it requested.
> 
> Allow msi-x settings when a minimal amount of vectors
> is provided.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Looks good, queued up for 2.6.30
