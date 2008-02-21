Return-Path: <linux-kernel-owner+w=401wt.eu-S934098AbYBUQf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098AbYBUQf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763684AbYBUQfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:35:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37323 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759695AbYBUQfR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:35:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Willies <jan@willies.info>
Subject: Re: 100% C0 with 2.6.25-rc
Date: Thu, 21 Feb 2008 17:33:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
References: <47BD600F.9090502@willies.info>
In-Reply-To: <47BD600F.9090502@willies.info>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802211733.54759.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of February 2008, Jan Willies wrote:
> Hi,
> 
> Since 2.6.25-rc1 I have a lot of wakeups/s (≈134191,4) and spend 100% in C0.
> It worked fine with 2.6.24 and commandline nolapic. Without nolapic I had 80k
> wakeups/s after some time, but not right from the start like now.  

We have a regression from 2.6.24, apparently interrupts-related.

> What useful information can I provide?

Let's see what the experts say.

Thanks,
Rafael
