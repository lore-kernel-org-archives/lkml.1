Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbXKTIAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbXKTIAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 03:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbXKTH7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:59:48 -0500
Received: from www.tglx.de ([62.245.132.106]:40867 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882AbXKTH7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:59:48 -0500
Date: Tue, 20 Nov 2007 08:59:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dan Aloni <da-x@monatomic.org>
cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: fix a deadlock in set_rtc_mmss()
In-Reply-To: <20071115165528.GA25520@localdomain>
Message-ID: <alpine.LFD.0.9999.0711200858190.7601@localhost.localdomain>
References: <20071115165528.GA25520@localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Dan Aloni wrote:

> Patch is valid only for 2.6.23.x, guessing from the recent arch/ changes 
> in 2.6.24-rc.

There is a backported patch already queued in the stable branch.

Thanks,

	tglx
