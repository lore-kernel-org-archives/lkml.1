Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbYGUR3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbYGUR3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 13:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYGUR2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 13:28:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58818
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbYGUR2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:28:52 -0400
Date: Mon, 21 Jul 2008 10:28:52 -0700 (PDT)
Message-Id: <20080721.102852.124418551.davem@davemloft.net>
To: kaber@trash.net
Cc: jmorris@namei.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <48847BA5.2020600@trash.net>
References: <4883E465.4050405@trash.net>
	<Xine.LNX.4.64.0807212143540.17349@us.intercode.com.au>
	<48847BA5.2020600@trash.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 21 Jul 2008 14:05:57 +0200

> The idea was that NETFILTER_ADVANCED=n enables everything needed
> by mainstream distributions and hides the rest. We can certainly
> change the default for this option, but that makes NETFILTER_ADVANCED
> pretty much useless.

A new feature cannot possibly be used by existing distributions.  I
think that's the main gripe.

Distributions themselves will enable the feature no matter what we
mark it's default as.

And once the feature thus becomes pervasive we can re-adjust the
default.
