Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbZBIBvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbZBIBvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZBIBvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:51:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58682
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbZBIBvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:51:10 -0500
Date: Sun, 08 Feb 2009 17:51:03 -0800 (PST)
Message-Id: <20090208.175103.257843097.davem@davemloft.net>
To: risto.suominen@gmail.com
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/002] de2104x: force correct order when writing to
 rx ring
From: David Miller <davem@davemloft.net>
In-Reply-To: <46e1c7760902071330u10427d33p3f49e82a2e4b1ddc@mail.gmail.com>
References: <46e1c7760902071330u10427d33p3f49e82a2e4b1ddc@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Risto Suominen <risto.suominen@gmail.com>
Date: Sat, 7 Feb 2009 23:30:24 +0200

> DescOwn should not be set, thus allowing the chip to use the descriptor, before
> everything else is set up correctly.
> 
> Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>

Applied.

Please send networking patches to netdev@vger.kernel.org, especially
so that your patch gets properly logged and tracked at:

	http://patchwork.ozlabs.org/project/netdev/list/

Thanks.
