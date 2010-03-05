Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab0CEOvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:51:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58677 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752675Ab0CEOu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:50:59 -0500
Date: Fri, 5 Mar 2010 09:50:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Weirdness in patch
In-Reply-To: <20100304210639.GA1392@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1003050949120.1677-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Greg KH wrote:

> On Thu, Mar 04, 2010 at 01:01:19PM -0800, Greg KH wrote:
> > Yes, the original patch is correct, but somehow the -all patches are not
> > getting generated correctly.  I'll go look into what broke in my
> > scripts.  Sorry about that, and thanks for letting me know.
> 
> Ok, it all seems to be working now, please let me know if anything looks
> wrong after master.kernel.org syncs everything out in about 30 minutes
> or so.

No, it's no good.  The current gregkh-all-2.6.33.patch gets lots of 
errors when I apply it to vanilla 2.6.33.

Alan Stern

