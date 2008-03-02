Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbYCBTlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbYCBTlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYCBTlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:41:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40264 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbYCBTlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:41:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: linux-v2.6.25-rc3 issue: nvidiafb: cannot ioremap FB base
Date: Sun, 2 Mar 2008 20:39:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       mingo@elte.hu, "Andrew Morton" <akpm@linux-foundation.org>
References: <38b2ab8a0802280607h46a89f04wdd190a7c87571668@mail.gmail.com> <38b2ab8a0802280608v2a75812boc11c7672c2d356a6@mail.gmail.com> <38b2ab8a0803010311v10b1537ehcef918f2c1f79912@mail.gmail.com>
In-Reply-To: <38b2ab8a0803010311v10b1537ehcef918f2c1f79912@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803022039.51634.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 1 of March 2008, Francis Moreau wrote:
> Ok,
> 
> After spending (too much) time to bisect this, I found that the looser
> commit is:
> 
> c31c7d4844ea4817692ae16bf70f9c96c05a50eb
> [ x86: CPA, fix alias checks ]

Please add yourself to the CC list of the Bugzilla entry at:
http://bugzilla.kernel.org/show_bug.cgi?id=10140

Thanks,
Rafael
