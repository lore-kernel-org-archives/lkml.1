Return-Path: <linux-kernel-owner+w=401wt.eu-S964854AbZLPWLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964854AbZLPWLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935824AbZLPWLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:11:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935801AbZLPWLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:11:50 -0500
Date: Wed, 16 Dec 2009 14:11:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912162257.00771.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912161410120.3556@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912162027.16574.rjw@sisk.pl> <alpine.LFD.2.00.0912161255080.3556@localhost.localdomain> <200912162257.00771.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Btw, what are the timings if you just force everything async? I think that 
worked on yur laptops, no?

It would be interestign to know - if only to see what the asymptotic upper 
bound is for all of this is..

		Linus
