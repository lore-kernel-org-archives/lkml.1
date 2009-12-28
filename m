Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbZL1KPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbZL1KPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZL1KPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:15:34 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36717 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZL1KPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:15:33 -0500
Subject: Re: [PATCH] x86,kmemcheck: Use KERN_WARNING for error reporting
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: vegard.nossum@gmail.com, akpm@linux-foundation.org, x86@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091228092855.GE24690@elte.hu>
References: <1261990935.4641.7.camel@penberg-laptop>
	 <20091228092855.GE24690@elte.hu>
Date: Mon, 28 Dec 2009 12:15:30 +0200
Message-Id: <1261995330.4641.8.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 10:28 +0100, Ingo Molnar wrote:
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > As suggested by Vegard Nossum, use KERN_WARNING for error reporting to make
> > sure kmemcheck reports end up in syslog.
> > 
> > Cc: Vegard Nossum <vegard.nossum@gmail.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > ---
> > Vegard, how do you want to merge this? Andrew? Ingo? I can also pick it
> > up in my tree if you ACK it.
> 
> Can apply it to x86/urgent, next to your other printk-loglevel-fixing patch.

OK, thanks Ingo!

