Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbXINUTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbXINUTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbXINUTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:19:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756862AbXINUTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:19:06 -0400
Date: Fri, 14 Sep 2007 13:18:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Medve Emilian-EMMEDVE1" <Emilian.Medve@freescale.com>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       <i2c@lm-sensors.org>, <linux-omap-open-source@linux.omap.com>
Subject: Re: [PATCH v3] Make the pr_*() family of macros in kernel.h
 complete
Message-Id: <20070914131828.2357a4a1.akpm@linux-foundation.org>
In-Reply-To: <598D5675D34BE349929AF5EDE9B03E270155578C@az33exm24.fsl.freescale.net>
References: <11896151802410-git-send-email-Emilian.Medve@Freescale.com>
	<598D5675D34BE349929AF5EDE9B03E270155578C@az33exm24.fsl.freescale.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 06:27:04 -0700 "Medve Emilian-EMMEDVE1" <Emilian.Medve@freescale.com> wrote:

> I realize this e-mail might be nuisance and time waster for you but I'm
> in need of advice. I apologize in advance for any commonsense cultural
> conventions I'm breaking.
> 
> I sent the below patch to four e-mail lists and it lead to orthogonal
> conversations about how the entire kernel logging system/mechanisms need
> to be re-written and thus such incremental improvements as these get out
> of focus...
> 
> In this case I started needing pr_err() and discovered that is defined
> already four times but not with global visibility as some other pr_*()
> from kernel.h (a subset of the entire family). I chose not to define it
> yet the fifth time but clean up the existing definitions and complete
> the family. For some reason it didn't go through even though I had some
> positive feedback. Now it seems I'm encouraged to really define the
> pr_err() for the fifth time...  Not quite sure what to do...

I normally troll the lkml list for patches like this and will sweep them
up.  But I'm presently 1400 messages in arrears so there is some latency.

I'll go grab this patch.
