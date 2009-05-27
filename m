Return-Path: <linux-kernel-owner+w=401wt.eu-S1761215AbZE0U44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215AbZE0U44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758923AbZE0U41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:56:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40873
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757405AbZE0U4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:56:25 -0400
Date: Wed, 27 May 2009 13:56:25 -0700 (PDT)
Message-Id: <20090527.135625.135313270.davem@davemloft.net>
To: plagnioj@jcrosoft.com
Cc: rmk+lkml@arm.linux.org.uk, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, timur@freescale.com,
       scottwood@freescale.com, yuan-bo.ye@motorola.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090527202701.GA16219@game.jcrosoft.org>
References: <20090527192909.GA32398@flint.arm.linux.org.uk>
	<20090527.132328.78091350.davem@davemloft.net>
	<20090527202701.GA16219@game.jcrosoft.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Date: Wed, 27 May 2009 22:27:01 +0200

> The SH, avr32, mips, x86 does not support it too IIRC

Actually x86 does support OF, via real OF firmware in fact :-)

