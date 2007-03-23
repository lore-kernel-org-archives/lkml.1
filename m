Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbXCWSPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbXCWSPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXCWSPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:15:08 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:41341 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbXCWSPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:15:07 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 23 Mar 2007 11:15:02 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
In-Reply-To: <20070323101042.GD11577@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0703231104480.25113@alien.or.mcafeemobile.com>
References: <20070323085910.GA11577@wotan.suse.de> <20070323100418.GA30740@elte.hu>
 <20070323101042.GD11577@wotan.suse.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, Nick Piggin wrote:

> On Fri, Mar 23, 2007 at 11:04:18AM +0100, Ingo Molnar wrote:
> > 
> > * Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > Implement queued spinlocks for i386. [...]
> > 
> > isnt this patented by MS? (which might not worry you SuSE/Novell guys, 
> > but it might be a worry for the rest of the world ;-)
> 
> I never thought a FIFO queue would be patentable.
> 
> Do you have a reference to the patent number?

FWIW, MS patented even the preprocessor in computer languages ;)
Holding a patent does not make it automatically enforceable.
I remember thare was a discussion time ago about queued spinlocks on lkml.



- Davide


