Return-Path: <linux-kernel-owner+w=401wt.eu-S1762489AbXJZMCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762489AbXJZMCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbXJZMCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:02:22 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:56935 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbXJZMCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:02:20 -0400
Date: Fri, 26 Oct 2007 13:02:13 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Remove always-true tests in irq handlers
Message-ID: <20071026120213.GA32421@linux-mips.org>
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org> <53d6c8049d4c3999a9d33d73e385d6161b5de2b7.1193390974.git.jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53d6c8049d4c3999a9d33d73e385d6161b5de2b7.1193390974.git.jeff@garzik.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 05:40:24AM -0400, Jeff Garzik wrote:

> In these drivers, dev_id is always non-NULL.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  arch/ia64/hp/sim/simeth.c                   |    5 -----
>  arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c |    5 +----

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
