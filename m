Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbZFAKM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbZFAKM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbZFAKMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:12:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49667
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756217AbZFAKMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:12:14 -0400
Date: Mon, 01 Jun 2009 03:12:15 -0700 (PDT)
Message-Id: <20090601.031215.109417436.davem@davemloft.net>
To: macro@linux-mips.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 3c509: Add missing EISA IDs
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0905310021070.15490@ftp.linux-mips.org>
References: <alpine.LFD.1.10.0905310021070.15490@ftp.linux-mips.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maciej W. Rozycki" <macro@linux-mips.org>
Date: Sun, 31 May 2009 00:40:31 +0100 (BST)

>  Several EISA device IDs for 3c509 family network cards are missing from 
> the driver, making the cards unusable in their EISA mode.  Here's a fix to 
> add them based on the EISA configuration files distributed by 3Com and our 
> eisa.ids database.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>

Applied, thanks.
