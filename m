Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbZHSWID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbZHSWID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 18:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZHSWIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 18:08:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:36353 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZHSWIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 18:08:01 -0400
Date: Wed, 19 Aug 2009 15:06:26 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 1/7] PM: Update kerneldoc comments in
 drivers/base/power/main.c
Message-ID: <20090819220626.GA28558@suse.de>
References: <200908122218.13975.rjw@sisk.pl>
 <200908170215.21173.rjw@sisk.pl>
 <200908170216.38401.rjw@sisk.pl>
 <200908192357.31358.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908192357.31358.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 11:57:31PM +0200, Rafael J. Wysocki wrote:
> On Monday 17 August 2009, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM: Update kerneldoc comments in drivers/base/power/main.c
> > 
> > The kerneldoc comments in drivers/base/power/main.c are generally
> > outdated and some of them don't describe the functions very
> > accurately.  Update them and standardize the format to use spaces
> > instead of tabs.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Any objections to this patch from anyone?  Greg, Alan, Randy?

Looks good to me:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

