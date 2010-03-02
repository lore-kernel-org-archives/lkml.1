Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab0CBX6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:58:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:41074 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab0CBX6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:58:15 -0500
Date: Tue, 2 Mar 2010 15:58:04 -0800
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@novell.com>,
       Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 56/62] msi-laptop: Support standard ec 66/62 command on
 MSI notebook and nebook
Message-ID: <20100302235804.GA2463@suse.de>
References: <20100302230933.GA32287@kroah.com>
 <1267572541-410-56-git-send-email-gregkh@suse.de>
 <20100302234219.GC13739@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302234219.GC13739@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 11:42:19PM +0000, Matthew Garrett wrote:
> On Tue, Mar 02, 2010 at 03:28:55PM -0800, Greg Kroah-Hartman wrote:
> > From: Lee, Chun-Yi <jlee@novell.com>
> > 
> > Suppport standard ec 66/62 command on MSI notebook and nebook. MSI
> > netbook and notebook already support 66/62 command, so, add new
> > get_state function, and put the old model to non-standard model, but
> > driver still support those old model.
> > 
> > Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> > Cc: Lennart Poettering <mzxreary@0pointer.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ACKed-by: Matthew Garrett <mjg@redhat.com>
> 
> Greg, could you send x86 platform drivers patches via me from now on? 
> There's some stuff in this patchset that isn't sane.

Ok, will do, you might want to update the MAINTAINERS file, as I just
went with the information in there, and what the get_maintainers.pl
script found by looking at the git history.

thanks,

greg k-h
