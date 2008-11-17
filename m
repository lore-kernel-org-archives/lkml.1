Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYKQVfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYKQVfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYKQVfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:35:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48305 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbYKQVe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:34:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: 2.6.28-rc5: Reported regressions from 2.6.27
Date: Mon, 17 Nov 2008 22:39:45 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera> <49209366.3060500@gmail.com>
In-Reply-To: <49209366.3060500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811172239.45987.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 16 of November 2008, Maxim Levitsky wrote:
> Just to note, here on acer aspire one suspend to disk is broken too.
> System suspends, and then hangs.

At which point exactly does it hang?

What's the most recent kernel you tried?

> If I shutdown the system, and then attempt resume, it resumes, and then hangs.

Again, at which point does it hang exactly?

I assume this doesn't happen with 2.6.27.  Is this correct?

Rafael
