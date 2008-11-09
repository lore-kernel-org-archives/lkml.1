Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbYKIWqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbYKIWqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 17:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbYKIWqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 17:46:06 -0500
Received: from vs02.svr02.mucip.net ([83.170.6.69]:42496 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbYKIWqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 17:46:05 -0500
Date: Sun, 9 Nov 2008 23:46:01 +0100
From: Bernhard Schmidt <berni@birkenwald.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Message-ID: <20081109224601.GA26690@obelix.birkenwald.de>
References: <20081104173300.GF6134@ics.muni.cz> <20081109105159.GA5867@joi> <20081109113304.GE4353@ics.muni.cz> <200811091424.10943.rjw@sisk.pl> <20081109200918.GA4361@ics.muni.cz> <20081109122835.10f410fa@infradead.org> <20081109203432.GB4361@ics.muni.cz> <20081109132438.5d81cd74@infradead.org> <alpine.LFD.2.00.0811092226050.12263@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811092226050.12263@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In gmane.linux.kernel, Thomas Gleixner wrote:

> Find below the lineup of the timers-fixes-for-linus branch of the tip
> tree (the same as Arjan posted minus the irq fixes)

I can confirm that this patch fixes the "need keypress to continue
booting" problem for me that hit me 100% before.

Regards,
Bernhard
