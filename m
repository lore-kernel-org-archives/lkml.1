Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYLSAI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYLSAI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYLSAIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:08:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37324
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbYLSAIO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:08:14 -0500
Date: Thu, 18 Dec 2008 16:08:15 -0800 (PST)
Message-Id: <20081218.160815.106790562.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Stop scaring users with "treason uncloaked!"
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0812190028560.12061@wrl-59.cs.helsinki.fi>
References: <1229638581.3726.546.camel@calx>
	<Pine.LNX.4.64.0812190028560.12061@wrl-59.cs.helsinki.fi>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Fri, 19 Dec 2008 00:33:46 +0200 (EET)

> On Thu, 18 Dec 2008, Matt Mackall wrote:
> 
> > These debug messages are uninformative and extremely alarming. Rather
> > than reporting a peer as a treacherous attacker, report it more
> > correctly as simply broken. 
> 
> Last time (well, ignoring some report on ancient vendor kernel) I've seen 
> this to trigger it wasn't the fault of the peer but ours (we sent past the 
> advertized window and window ended up being shrunk to zero). I agree that 
> the message as-is is not very good but your change is not very good 
> either.
 ...
> This won't apply to net-next on which you should base anything new (and 
> net related).

Agreed.
