Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbYEDKg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbYEDKg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 06:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbYEDKgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 06:36:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36134
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbYEDKgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 06:36:46 -0400
Date: Sun, 04 May 2008 03:36:45 -0700 (PDT)
Message-Id: <20080504.033645.15975561.davem@davemloft.net>
To: devzero@web.de
Cc: akpm@linux-foundation.org, g4klx@g4klx.demon.co.uk,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 24rc8: unregister_netdevice: waiting for ... to become free
From: David Miller <davem@davemloft.net>
In-Reply-To: <264300966@web.de>
References: <264300966@web.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: devzero@web.de
Date: Sun, 04 May 2008 11:33:12 +0200

> > Roland, does this fix your bug?
> 
> Yes! 
> With this patch i can unload the nic driver again.

Thanks for testing, I'll push this fix to Linus.
