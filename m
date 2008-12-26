Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYLZIDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYLZIDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 03:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbYLZIC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 03:02:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38552
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752797AbYLZIC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 03:02:58 -0500
Date: Fri, 26 Dec 2008 00:03:00 -0800 (PST)
Message-Id: <20081226.000300.75987642.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: hannes@hanneseder.net, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/27] drivers/net/igb: remove dead code (function
 'igb_read_pci_cfg')
From: David Miller <davem@davemloft.net>
In-Reply-To: <9929d2390812221430j1bc15607m58dd07a6ac8dec5@mail.gmail.com>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	<20081222191632.11807.3776.stgit@vmbox.hanneseder.net>
	<9929d2390812221430j1bc15607m58dd07a6ac8dec5@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
Date: Mon, 22 Dec 2008 14:30:00 -0800

> On Mon, Dec 22, 2008 at 11:16 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> > Fix this warning:
> >
> >  drivers/net/igb/e1000_mac.c:54: warning: 'igb_read_pci_cfg' defined but not used
> >
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
 ...
> Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
