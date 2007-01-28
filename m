Return-Path: <linux-kernel-owner+w=401wt.eu-S932998AbXA1XmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbXA1XmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 18:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933000AbXA1XmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 18:42:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57361
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932998AbXA1XmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 18:42:20 -0500
Date: Sun, 28 Jan 2007 15:42:19 -0800 (PST)
Message-Id: <20070128.154219.55509563.davem@davemloft.net>
To: jeff@garzik.org
Cc: benh@kernel.crashing.org, ebiederm@xmission.com, greg@kroah.com,
       tony.luck@intel.com, grundler@parisc-linux.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 0/6] MSI portability cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <45BD0BDC.40205@garzik.org>
References: <m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	<1170015805.26655.15.camel@localhost.localdomain>
	<45BD0BDC.40205@garzik.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Sun, 28 Jan 2007 15:47:24 -0500

> I think the high-level ops approach makes more sense.  It's more future 
> proof, in addition to covering all existing implementations.

I totally agree with this.
