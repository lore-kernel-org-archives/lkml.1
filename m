Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYB0Thg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYB0Thg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbYB0Th2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:37:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44367
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755947AbYB0Th1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:37:27 -0500
Date: Wed, 27 Feb 2008 11:37:12 -0800 (PST)
Message-Id: <20080227.113712.145035043.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [BUG] 2.6.25-rc3 hangs in early boot on Sun Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <18373.46849.662187.25323@alkaid.it.uu.se>
References: <20080226.164900.193701385.davem@davemloft.net>
	<20080226.170613.107688605.davem@davemloft.net>
	<18373.46849.662187.25323@alkaid.it.uu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Wed, 27 Feb 2008 20:16:17 +0100

> Thanks, 2.6.25-rc3 plus this patch works fine on my Ultra5.

Thank you for testing.
