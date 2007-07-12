Return-Path: <linux-kernel-owner+w=401wt.eu-S936970AbXGLAfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936970AbXGLAfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935061AbXGLAes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:34:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40994 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937909AbXGLAeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:34:46 -0400
Date: Wed, 11 Jul 2007 17:33:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: generic clockevents/ (hr)time(r) patches was Re: -mm merge
 plans for 2.6.23
Message-Id: <20070711173354.de4d51ea.akpm@linux-foundation.org>
In-Reply-To: <200707120159.24355.ak@suse.de>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<1184195008.12353.182.camel@chaos>
	<200707120159.24355.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 01:59:23 +0200
Andi Kleen <ak@suse.de> wrote:

> 
> > Andi, any objections against the above i386 fixlets ?
> 
> No, they are fine for me.
> 

OK, I queued them up for an akpm->linus transfer.  Which will of course be
abandoned if an akpm->andi or andi->linus merge happens in the next week or
so.
