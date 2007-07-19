Return-Path: <linux-kernel-owner+w=401wt.eu-S933417AbXGSXoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbXGSXoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758637AbXGSXo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:44:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45126
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758419AbXGSXo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:44:27 -0400
Date: Thu, 19 Jul 2007 16:44:26 -0700 (PDT)
Message-Id: <20070719.164426.48528683.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fallout from [SPARC64]: Simplify VDC device probing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070719231931.GX21668@ftp.linux.org.uk>
References: <20070719231931.GX21668@ftp.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 20 Jul 2007 00:19:31 +0100

> 	... hopefully that's what you meant here...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Yes, this fix is already in my tree which I'll push to
Linus later tonight.

Thanks Al.
