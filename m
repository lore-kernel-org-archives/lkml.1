Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbXKLWvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbXKLWvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760012AbXKLWuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:50:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43206
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760019AbXKLWut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:50:49 -0500
Date: Mon, 12 Nov 2007 14:50:49 -0800 (PST)
Message-Id: <20071112.145049.125228420.davem@davemloft.net>
To: ak@suse.de
Cc: gorcunov@gmail.com, tglx@linutronix.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [IA32-EMU] Remove trailing spaces
From: David Miller <davem@davemloft.net>
In-Reply-To: <200711122201.45269.ak@suse.de>
References: <20071112181747.GE7296@cvg>
	<200711122201.45269.ak@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@suse.de>
Date: Mon, 12 Nov 2007 22:01:45 +0100

> On Monday 12 November 2007 19:17:47 Cyrill Gorcunov wrote:
> > This patch does remove trailing spaces from
> > source files.
> 
> That will just cause a zillion patches to not apply anymore
> with exactly 0 benefit.

You'll survive the x86 merge and you'll survive this
patch too.
