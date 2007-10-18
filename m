Return-Path: <linux-kernel-owner+w=401wt.eu-S1762754AbXJRCku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762754AbXJRCku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbXJRCkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:40:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35280
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752513AbXJRCkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:40:42 -0400
Date: Wed, 17 Oct 2007 19:40:41 -0700 (PDT)
Message-Id: <20071017.194041.38322418.davem@davemloft.net>
To: matthias.kaehlcke@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Videopix Frame Grabber: Convert device_lock_sem to
 mutex
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071016171851.GB31288@traven>
References: <20071016171851.GB31288@traven>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Date: Tue, 16 Oct 2007 19:18:52 +0200

> Videopix Frame Grabber: Convert the semaphore device_lock_sem to the
> mutex API
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Applied, thanks.
