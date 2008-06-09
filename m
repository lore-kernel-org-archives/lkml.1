Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYFIC1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYFIC1D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 22:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbYFIC0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 22:26:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32849
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755121AbYFIC0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 22:26:51 -0400
Date: Sun, 08 Jun 2008 19:26:51 -0700 (PDT)
Message-Id: <20080608.192651.193722134.davem@davemloft.net>
To: jeff@garzik.org
Cc: jacliburn@bellsouth.net, w@1wt.eu, pupilla@hotmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [patch 00/50] 2.6.25.6 -stable review
From: David Miller <davem@davemloft.net>
In-Reply-To: <484C3C13.7020609@garzik.org>
References: <20080608.071051.212882594.davem@davemloft.net>
	<20080608103835.0c0b1e83@osprey.hogchain.net>
	<484C3C13.7020609@garzik.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Sun, 08 Jun 2008 16:07:47 -0400

> Jay Cliburn wrote:
> > David's admonition tells me I'm doing it wrong, and that I should
> > submit the stable patch to Jeff as well.  Am I right?
> 
> I usually encourage a more-parallel process where you simply email 
> stable@kernel.org with the upstream commit id of the change(s) in question.

Right, and if Jeff wants to work things that way for the
networking drivers that's fine.

Personally, I like to make sure some time passes between when
a fix goes into Linus's tree and when I push it into -stable
because time is often what shakes out the last remaining problems
introduced by some change no matter how seeming obvious the
patch is.
