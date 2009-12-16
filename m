Return-Path: <linux-kernel-owner+w=401wt.eu-S964802AbZLPU71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbZLPU71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763287AbZLPU7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:59:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763278AbZLPU7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:59:21 -0500
Date: Wed, 16 Dec 2009 12:59:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912162027.16574.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912161255080.3556@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912160311.05915.rjw@sisk.pl> <alpine.LFD.2.00.0912160737350.7454@localhost.localdomain> <200912162027.16574.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > Do you have any sample timing output with devices listed?
> 
> I'm going to generate one shortly.

>From my bootup timings, I have this memory of SATA link bringup being 
noticeable. I wonder if that is the case on resume too...

		Linus
