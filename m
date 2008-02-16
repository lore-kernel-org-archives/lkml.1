Return-Path: <linux-kernel-owner+w=401wt.eu-S1762218AbYBPAQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218AbYBPAQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbYBPAQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:16:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57987
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbYBPAQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:16:20 -0500
Date: Fri, 15 Feb 2008 16:16:51 -0800 (PST)
Message-Id: <20080215.161651.32391345.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080215160314.GA13609@havoc.gtf.org>
References: <20080215160314.GA13609@havoc.gtf.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 15 Feb 2008 11:03:14 -0500

> Please pull from 'upstream-davem' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git upstream-davem

Pulled and pushed out.

As I mentioned to John Linville just now, I'm going to try
and keep net-2.6 running as long as I can without rebasing.

So you can just keep piling patches into your upstream-davem
branch without fear of my turning your world upside down
with a rebase :-)
