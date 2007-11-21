Return-Path: <linux-kernel-owner+w=401wt.eu-S1763308AbXKUBcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308AbXKUBcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463AbXKUBcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:32:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53170
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755204AbXKUBci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:32:38 -0500
Date: Tue, 20 Nov 2007 17:32:37 -0800 (PST)
Message-Id: <20071120.173237.64412778.davem@davemloft.net>
To: gorcunov@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] SPARC64: check for possible NULL pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071120172833.GB7275@cvg>
References: <20071120172833.GB7275@cvg>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Tue, 20 Nov 2007 20:28:33 +0300

> From: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> This patch adds checking for possible NULL pointer dereference
> if of_find_property() failed.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Applied, thanks.
