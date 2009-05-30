Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbZE3Dt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbZE3Dt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 23:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbZE3Dtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 23:49:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58071
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482AbZE3Dty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 23:49:54 -0400
Date: Fri, 29 May 2009 20:49:54 -0700 (PDT)
Message-Id: <20090529.204954.176335535.davem@davemloft.net>
To: mehaf@gedanken.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] networking: Add write/clear capability to /proc/net/dev
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A207D52.9000407@gedanken.com>
References: <4A207D52.9000407@gedanken.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Mehaffey <mehaf@gedanken.com>
Date: Fri, 29 May 2009 17:26:58 -0700

> There is currently no way to reset networking statistics other than to
> rmmod the interface and reinstall it.

This has been NAK'd a thousand times in the past.  We're not
adding a change like this, sorry.

Do it in userspace or similar.
