Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbZKDQhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbZKDQhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbZKDQhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:37:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49545
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756888AbZKDQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:37:13 -0500
Date: Wed, 04 Nov 2009 08:37:38 -0800 (PST)
Message-Id: <20091104.083738.170517131.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NET: sungem, use spin_trylock_irqsave
From: David Miller <davem@davemloft.net>
In-Reply-To: <1257350818-4194-1-git-send-email-jirislaby@gmail.com>
References: <1257350818-4194-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Wed,  4 Nov 2009 17:06:58 +0100

> Use spin_trylock_irqsave instead of open-coded
> local_irq_save+spin_trylock.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Applied, thanks.
