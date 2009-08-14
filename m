Return-Path: <linux-kernel-owner+w=401wt.eu-S932394AbZHNOpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbZHNOpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 10:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932358AbZHNOpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 10:45:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46871 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932355AbZHNOpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 10:45:30 -0400
Date: Fri, 14 Aug 2009 10:45:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
In-Reply-To: <200908132353.54902.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908141044220.2987-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Rafael J. Wysocki wrote:

> > No, I've only tested it with a few selected drivers.  I'm going to try the
> > "async everyone" scenario, though.
> 
> On HP nx6325 booted with init=/bin/bash it doesn't pass the
> 'echo devices > /sys/power/pm_test && echo mem > /sys/power/state' test.
> 
> The suspend part actually seems to work, but the resume part crashes
> miserably.

Any details?  Can you tell where it crashes?

Maybe I'll try it here just to see what happens...

Alan Stern

