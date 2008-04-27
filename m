Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYD0HRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYD0HRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 03:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYD0HRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 03:17:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49145
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbYD0HRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 03:17:17 -0400
Date: Sun, 27 Apr 2008 00:17:09 -0700 (PDT)
Message-Id: <20080427.001709.221075811.davem@davemloft.net>
To: cpeterso@cpeterso.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix uninitialized variable warning in
 crypto/async_tx/async_tx.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <a24804730804270012ycdbd962v377e0a3b9a379013@mail.gmail.com>
References: <a24804730804270012ycdbd962v377e0a3b9a379013@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chris Peterson" <cpeterso@cpeterso.com>
Date: Sun, 27 Apr 2008 00:12:22 -0700

> --- linux-2.6.25-git7/crypto/async_tx/async_tx.c	2008-04-25
> 22:46:24.000000000 -0700

Chris, your email client is adding line breaks and other transformation
which are corrupting the patches you are sending.

Please correct this and resubmit your patch.

Thanks.
