Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbXFVXV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbXFVXV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbXFVXVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:21:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245AbXFVXVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:21:50 -0400
Date: Fri, 22 Jun 2007 16:21:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Malte Cornils <malte@cornils.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: PCI setup hangs on Asus Notebook (nolapic helps)
Message-Id: <20070622162139.c484ae88.akpm@linux-foundation.org>
In-Reply-To: <200706221943.35517.malte@cornils.net>
References: <200706141505.27380.malte@cornils.net>
	<20070621052741.a44dc7f2.akpm@linux-foundation.org>
	<200706221943.35517.malte@cornils.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 22 Jun 2007 19:43:34 +0200 Malte Cornils <malte@cornils.net> wrote:
> Hello Andrew,
> 
> On Thursday, 21. Juni 2007 14:27 Andrew Morton wrote:
> > > Booting with nolapic helps, but makes the SATAized IDE controller buggy
> > > [...] There have been other reports of the problem on Asus notebooks. I've
> > > collected some links:[...]
> 
> > Are any of these problems new behaviour, or has it always done this?
> >
> > If there _is_ new behaviour here, are you able to identify which earlier
> > kernel versions did not exhibit it?
> 
> The patch causing that behaviour went in between 2.6.18 and 2.6.19rc-1. I have 
> some 100 patches to go bisecting the bug, but it's slow work due to 
> difficulties in getting physical access to the machine for extended periods 
> of time.
> 
> I'll be sure to let you know when I have the exact commit. That may be at any 
> time from tomorrow to beginning of July, I'm not sure yet what my free time 
> allows.
> 

OK, thanks.  There's no rush but please do persist...
