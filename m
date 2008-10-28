Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYJ1RIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYJ1RIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYJ1RIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:08:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229AbYJ1RIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:08:04 -0400
Date: Tue, 28 Oct 2008 10:07:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Matthias Kaehlcke <matthias@kaehlcke.net>, kernel@wantstofly.org,
       rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ep93xx: fix OHCI DMA mask
Message-Id: <20081028100719.531e4c94.akpm@linux-foundation.org>
In-Reply-To: <20081028101106.GB6099@fluff.org.uk>
References: <20081028081950.GA2930@traven>
	<20081028101106.GB6099@fluff.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 10:11:06 +0000 Ben Dooks <ben-linux@fluff.org> wrote:

> On Tue, Oct 28, 2008 at 09:19:50AM +0100, Matthias Kaehlcke wrote:
> > ep93xx: Fix OHCI DMA mask
> > 
> > Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
> 
> Did this really have to go to so many people?

It's better than too few!  Bugfixes are important (most important?)
and our lossage rate on patches is scary high.

In particular, please don't chase people's bugfixes off linux-kernel,
because then I won't see them.  I'd guess that somewhere between a
quarter and a half of the bugfixes which I scoop off the list would
otherwise not have been applied.

Spread the wealth!
