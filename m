Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbYFHPiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbYFHPiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 11:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbYFHPim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 11:38:42 -0400
Received: from fmailhost01.isp.att.net ([207.115.11.51]:47790 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbYFHPil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 11:38:41 -0400
X-Originating-IP: [68.222.90.36]
Date: Sun, 8 Jun 2008 10:38:35 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: David Miller <davem@davemloft.net>
Cc: w@1wt.eu, pupilla@hotmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, chrisw@sous-sol.org, jeff@garzik.org
Subject: Re: [patch 00/50] 2.6.25.6 -stable review
Message-ID: <20080608103835.0c0b1e83@osprey.hogchain.net>
In-Reply-To: <20080608.071051.212882594.davem@davemloft.net>
References: <20080607204325.GJ5609@1wt.eu>
	<BAY103-DAV7370611E1B3FEA8FD69B9B2B10@phx.gbl>
	<20080608123601.GB10491@1wt.eu>
	<20080608.071051.212882594.davem@davemloft.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Jun 2008 07:10:51 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:


> If you ask me in the future about the status of a -stable
> patch from the networking, I'll let you know exactly what
> is happening to that patch wrt. stable.  I rarely forget
> to submit an appropriate patch, and when I do forget you
> merely have to let me know (rather than submitting it
> to -stable directly, please don't do that) so that I can
> fit it in with what I plan to submit to -stable already.


As a netdev driver maintainer, I've been following this workflow for
patches that need to go to -stable:

1.  I submit a mainline patch to Jeff Garzik.
2.  Jeff submits to David.
3.  David submits to Linus.
4.  Linus merges patch into mainline.
5.  I extract mainline commit ID.
6.  I apply and test patch against appropriate 2.6.x.y git tree.
7.  I submit patch directly to -stable.

David's admonition tells me I'm doing it wrong, and that I should
submit the stable patch to Jeff as well.  Am I right?

Jay
