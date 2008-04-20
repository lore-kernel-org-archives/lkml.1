Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbYDTBio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbYDTBio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 21:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYDTBie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 21:38:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52359
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751984AbYDTBid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 21:38:33 -0400
Date: Sat, 19 Apr 2008 18:38:34 -0700 (PDT)
Message-Id: <20080419.183834.238901544.davem@davemloft.net>
To: pidoux@ccr.jussieu.fr
Cc: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
       linux-hams@vger.kernel.org
Subject: Re: [PATCH] rose_node_list_lock was not released before returning
 to user space
From: David Miller <davem@davemloft.net>
In-Reply-To: <480A6034.1080806@ccr.jussieu.fr>
References: <480A6034.1080806@ccr.jussieu.fr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernard Pidoux <pidoux@ccr.jussieu.fr>
Date: Sat, 19 Apr 2008 23:12:20 +0200

> I have already submited this patch on January 11, 2008.
> As the bug is still present, I resend it.

I'll apply this fix, thanks a lot Bernard.
