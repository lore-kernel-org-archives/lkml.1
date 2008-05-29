Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYE2Ie3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYE2Ie3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYE2IeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:34:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48977
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbYE2IeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:34:17 -0400
Date: Thu, 29 May 2008 01:34:12 -0700 (PDT)
Message-Id: <20080529.013412.180232731.davem@davemloft.net>
To: marcel@holtmann.org
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] bluetooth: fix locking bug in the rfcomm socket
 cleanup handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <AD9D7FA8-9626-473B-838F-B05ED91742D8@holtmann.org>
References: <20080528213006.02964148@infradead.org>
	<AD9D7FA8-9626-473B-838F-B05ED91742D8@holtmann.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Thu, 29 May 2008 08:49:53 +0200

> Acked-by: Marcel Holtmann <marcel@holtmann.org>
> 
> David, you might wanna queue this up for stable, too.

Patch applied, and I will queue up for stable, thanks.
