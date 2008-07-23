Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYGWXnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYGWXnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYGWXm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:42:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44492
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752146AbYGWXm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:42:56 -0400
Date: Wed, 23 Jul 2008 16:42:56 -0700 (PDT)
Message-Id: <20080723.164256.261160675.davem@davemloft.net>
To: kaber@trash.net
Cc: torvalds@linux-foundation.org, jmorris@namei.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <4884F28E.6040903@trash.net>
References: <20080721.102852.124418551.davem@davemloft.net>
	<alpine.LFD.1.10.0807211037200.31863@woody.linux-foundation.org>
	<4884F28E.6040903@trash.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 21 Jul 2008 22:33:18 +0200

> Its not needed today of course, so the attached patch changes it
> to depend on NETFILTER_ADVANCED and removes the default.

I've applied this, thanks Patrick.
