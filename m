Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbXLRPLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbXLRPLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbXLRPLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:11:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:59095 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833AbXLRPLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:11:08 -0500
Date: Tue, 18 Dec 2007 18:10:07 +0300
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: Jeff Garzik <jeff@garzik.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH/RFC] [POWERPC] Add fixed-phy support for fs_enet
Message-ID: <20071218181007.5ac05511@kernel.crashing.org>
In-Reply-To: <4767042E.2070903@garzik.org>
References: <47601027.2080104@scram.de>
	<4767042E.2070903@garzik.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 18:20:14 -0500
Jeff Garzik wrote:

> Jochen Friedrich wrote:
> > This patch adds support to use the fixed-link property
> > of an ethernet node to fs_enet for the
> > CONFIG_PPC_CPM_NEW_BINDING case.
> > 
> > Signed-off-by: Jochen Friedrich <jochen@scram.de>
Acked-by: Vitaly Bordug <vitb@kernel.crashing.org>

Jochen,
will you resend the patch with all acks to paulus? I'll do that if not.


-- 
Sincerely, Vitaly
