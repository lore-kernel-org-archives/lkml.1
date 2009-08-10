Return-Path: <linux-kernel-owner+w=401wt.eu-S932250AbZHJQqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbZHJQqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204AbZHJQqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:46:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150AbZHJQqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:46:53 -0400
Date: Mon, 10 Aug 2009 09:45:42 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-pm@lists.linux-foundation.org,
       lethal@linux-sh.org, stern@rowland.harvard.edu, pavel@ucw.cz,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM: kill dev_pm_ops platform warning for now
Message-ID: <20090810164542.GA28405@suse.de>
References: <20090807083430.31389.98825.sendpatchset@rx1.opensource.se>
 <200908081516.24018.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908081516.24018.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08, 2009 at 03:16:23PM +0200, Rafael J. Wysocki wrote:
> On Friday 07 August 2009, Magnus Damm wrote:
> > From: Magnus Damm <damm@igel.co.jp>
> > 
> > Remove the platform device runtime dev_pm_ops warning
> > for now. No point in upsetting users of non-rc kernels.
> > 
> > Signed-off-by: Magnus Damm <damm@igel.co.jp>
> 
> Thanks for the patch, I modified the changelog a bit.
> 
> Greg, do you agree with the patch below?

Yes, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patch and forward it on.

Or do you need me to forward it?

thanks,

greg k-h
