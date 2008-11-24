Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYKXWtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYKXWtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 17:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYKXWtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 17:49:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59188
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753353AbYKXWtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 17:49:19 -0500
Date: Mon, 24 Nov 2008 14:49:19 -0800 (PST)
Message-Id: <20081124.144919.41364747.davem@davemloft.net>
To: jirka@pirko.cz
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com, netdev@vger.kernel.org
Subject: Re: [PATCH] tokenring/3c359.c: Prevent possible mem leak when open
 failed
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081123214410.44810f99@jirka.pirko.cz>
References: <20081123214410.44810f99@jirka.pirko.cz>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jirka Pirko <jirka@pirko.cz>
Date: Sun, 23 Nov 2008 21:44:10 +0100

> Freeing previously allocated buffers in case of error.
> 
> Signed-off-by: Jirka Pirko <jirka@pirko.cz>

Applied.
