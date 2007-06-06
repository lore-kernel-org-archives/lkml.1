Return-Path: <linux-kernel-owner+w=401wt.eu-S965827AbXFFXAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965827AbXFFXAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965747AbXFFXAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:00:06 -0400
Received: from www.osadl.org ([213.239.205.134]:42522 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965744AbXFFXAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:00:04 -0400
Subject: Re: Big problems applying patch-2.6.21.3-rt9
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Ingo Molnar <mingo@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46673964.1000004@am.sony.com>
References: <46673964.1000004@am.sony.com>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 00:59:59 +0200
Message-Id: <1181170799.4404.271.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 15:47 -0700, Tim Bird wrote:
> Ingo,
> 
> I saw lots of problems trying to apply the latest rt-preempt patch.
> Maybe some bits got included by mistake in the patch?
> 
> Here's what I saw:
> $ wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.3.tar.bz2

That should be 2.6.21.tar.bz2

The patch contains the .3 patch already. Unfortunately it used the wrong
numbering scheme :(

Sorry,

	tglx


