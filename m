Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbYFLXOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbYFLXOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 19:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbYFLXOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 19:14:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54396
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753400AbYFLXOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 19:14:19 -0400
Date: Thu, 12 Jun 2008 16:14:16 -0700 (PDT)
Message-Id: <20080612.161416.82163498.davem@davemloft.net>
To: jeff@garzik.org
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver updates for .27
From: David Miller <davem@davemloft.net>
In-Reply-To: <4851A695.7050706@garzik.org>
References: <48519E57.3030906@garzik.org>
	<20080612.152214.21877307.davem@davemloft.net>
	<4851A695.7050706@garzik.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Thu, 12 Jun 2008 18:43:33 -0400

> David Miller wrote:
> > "Author" is always who wrote the patch, and I think it's important to
> > be consistent in that area.
> 
> "always"?  There are /plenty/ of occasions, usually at big corps, where 
> the Author is not the person who wrote the patch, but rather the person 
> who sent the patch.
> 
> And you'll note that all Linus's tools capture that -- author is patch 
> sender -- albeit with optional From parsing from patch commit description.

I guess that's a compelling enough argument.  I'll pull your
original tree, thanks Jeff.
