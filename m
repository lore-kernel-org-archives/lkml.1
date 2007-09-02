Return-Path: <linux-kernel-owner+w=401wt.eu-S965546AbXIBQrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965546AbXIBQrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 12:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbXIBQrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 12:47:25 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:12308 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597AbXIBQrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 12:47:24 -0400
Date: Sun, 2 Sep 2007 09:46:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86/x86-64 PCI domain support
Message-Id: <20070902094637.6750f068.randy.dunlap@oracle.com>
In-Reply-To: <46D9EA5B.9010101@garzik.org>
References: <20070901143223.GA32216@havoc.gtf.org>
	<200709020000.03375.ak@suse.de>
	<46D9E254.6010702@garzik.org>
	<200709020026.52725.ak@suse.de>
	<46D9EA5B.9010101@garzik.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Sep 2007 18:40:27 -0400 Jeff Garzik wrote:

> Andi Kleen wrote:
> >>> The second function is redundant? 
> >> No, it's a hook we must implement, when CONFIG_PCI_DOMAINS is enabled.
> > 
> > Then the other function is redundant.
> 
> No, both functions are required by the interface.

by what interface?  and why, please?  (instead of just stating "required")


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
