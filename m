Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbXJZK5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbXJZK5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXJZK4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:56:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39699
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbXJZK4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:56:50 -0400
Date: Fri, 26 Oct 2007 03:56:52 -0700 (PDT)
Message-Id: <20071026.035652.189993268.davem@davemloft.net>
To: bunk@kernel.org
Cc: ryanr23@gmail.com, samuel@sortiz.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [2.6 patch] make ircomm_tty static
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071024162355.GZ30533@stusta.de>
References: <20071024162355.GZ30533@stusta.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Wed, 24 Oct 2007 18:23:55 +0200

> ircomm_tty can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied.
