Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYADLre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYADLre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYADLrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:47:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51249
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbYADLrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:47:24 -0500
Date: Fri, 04 Jan 2008 03:47:23 -0800 (PST)
Message-Id: <20080104.034723.19852882.davem@davemloft.net>
To: mingo@elte.hu
Cc: jengelh@computergmbh.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Use __u64 in aligned_u64's definition
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080104110333.GA26149@elte.hu>
References: <alpine.LFD.1.00.0801021341070.3010@woody.linux-foundation.org>
	<Pine.LNX.4.64.0801022243450.14900@fbirervta.pbzchgretzou.qr>
	<20080104110333.GA26149@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 4 Jan 2008 12:03:33 +0100

> 
> * Jan Engelhardt <jengelh@computergmbh.de> wrote:
> 
> > Well you can also apply it right now, then it's done and life can go 
> > on.
> 
> which part of the "it's an unnecessary distraction" concept didnt you 
> understand? We are in -rc6 and all the codebase is in deep freeze. Delay 
> your patch to when the 2.6.25 merge window starts and life can go on.

Also, it's easy to just queue it up into whatever subsystem
tree you are current submitting patches into if you fear it
getting lost.

You can send it to Andrew Morton for the -mm tree, as another
alternative.

In any event, yes, trying to get Linus to apply it now is very
wrong and indeed distracting.
