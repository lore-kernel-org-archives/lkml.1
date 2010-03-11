Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165Ab0CKSi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:38:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58581
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758014Ab0CKSiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:38:17 -0500
Date: Thu, 11 Mar 2010 10:38:36 -0800 (PST)
Message-Id: <20100311.103836.13755632.davem@davemloft.net>
To: sshtylyov@mvista.com
Cc: grant.likely@secretlab.ca, monstr@monstr.eu, gregkh@suse.de,
       benh@kernel.crashing.org, akpm@linux-foundation.org,
       sfr@canb.auug.org.au, jgarzik@pobox.com, ben-linux@fluff.org,
       dwmw2@infradead.org, jeremy.kerr@canonical.com, James.Bottomley@suse.de,
       broonie@opensource.wolfsonmicro.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-scsi@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH 21/37] drivers/ata: use .dev.of_node instead of .node
 in struct of_device
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B9936F2.3020105@ru.mvista.com>
References: <20100311174830.4824.19820.stgit@angua>
	<20100311180543.4824.70491.stgit@angua>
	<4B9936F2.3020105@ru.mvista.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sshtylyov@mvista.com>
Date: Thu, 11 Mar 2010 21:31:14 +0300

>   Should probably have been 2 patches instead of one, as drivers/ata/
>   and drivers/ide/ are different subsystems...

No, he should consolidate these changes _MORE_ not less.

The patch set is already too large to review at it is!
