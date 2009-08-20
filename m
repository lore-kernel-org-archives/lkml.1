Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZHTOAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZHTOAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbZHTOAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:00:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49099 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754206AbZHTOAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:00:19 -0400
Date: Thu, 20 Aug 2009 10:00:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 1/7] PM: Update kerneldoc comments in
 drivers/base/power/main.c
In-Reply-To: <200908200114.51290.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908200959410.3048-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009, Rafael J. Wysocki wrote:

> On Thursday 20 August 2009, Alan Stern wrote:
> > On Wed, 19 Aug 2009, Rafael J. Wysocki wrote:
> > 
> > > On Monday 17 August 2009, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > Subject: PM: Update kerneldoc comments in drivers/base/power/main.c
> > > > 
> > > > The kerneldoc comments in drivers/base/power/main.c are generally
> > > > outdated and some of them don't describe the functions very
> > > > accurately.  Update them and standardize the format to use spaces
> > > > instead of tabs.
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Any objections to this patch from anyone?  Greg, Alan, Randy?
> > 
> > Just some very minor changes.
> 
> Thanks for spotting the mistakes.
> Updated patch is appended.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Update kerneldoc comments in drivers/base/power/main.c
> 
> The kerneldoc comments in drivers/base/power/main.c are generally
> outdated and some of them don't describe the functions very
> accurately.  Update them and standardize the format to use spaces
> instead of tabs.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

