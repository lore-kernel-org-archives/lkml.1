Return-Path: <linux-kernel-owner+w=401wt.eu-S1763651AbYD3Mk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763651AbYD3Mk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbYD3MkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:40:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754394AbYD3MkS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:40:18 -0400
Date: Wed, 30 Apr 2008 05:38:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] let setup_irq reenable a shared irq
Message-Id: <20080430053814.06611928.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301432080.6003@apollo.tec.linutronix.de>
References: <1209557398-8228-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
	<alpine.LFD.1.10.0804301432080.6003@apollo.tec.linutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 14:32:58 +0200 (CEST) Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 30 Apr 2008, Uwe Kleine-König wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> 
> I have the fixed version already queued for linus since yesterday :)
> 

Where is it queued?
