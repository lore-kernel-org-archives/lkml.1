Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbZKRH00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbZKRH00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 02:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZKRH0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 02:26:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60984
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859AbZKRH0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 02:26:25 -0500
Date: Tue, 17 Nov 2009 23:26:42 -0800 (PST)
Message-Id: <20091117.232642.201632251.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sparclinux@vger.kernel.org
Subject: Re: [patch 04/13] sparc: Fixup last users of irq_chip->typename 
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091117224916.491090342@linutronix.de>
References: <20091117224852.846805939@linutronix.de>
	<20091117224916.491090342@linutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 17 Nov 2009 22:50:40 -0000

> The typename member of struct irq_chip was kept for migration purposes
> and is obsolete since more than 2 years. Fix up the leftovers.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: David S. Miller <davem@davemloft.net>
