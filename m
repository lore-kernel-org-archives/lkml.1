Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab0BRRKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:10:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:33933 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab0BRRKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:10:22 -0500
Date: Thu, 18 Feb 2010 09:09:23 -0800
From: Greg KH <gregkh@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg KH <greg@kroah.com>,
       Bernhard Schiffner <bernhard@schiffner-limbach.de>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3 V2] staging: r8187se: Miscellaneous cleanups
Message-ID: <20100218170923.GA1614@suse.de>
References: <4b7963d0.cocDj1pGMQ3LKF4a%Larry.Finger@lwfinger.net>
 <20100218160340.GH21785@kroah.com>
 <4B7D7270.6030900@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7D7270.6030900@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 11:01:36AM -0600, Larry Finger wrote:
> On 02/18/2010 10:03 AM, Greg KH wrote:
> > On Mon, Feb 15, 2010 at 09:10:08AM -0600, Larry Finger wrote:
> > 
> > Ick, I just applied your first versions of these patches.  What was the
> > difference here?  Care to look at the next linux-next tree and see if I
> > missed anything?
> > 
> > sorry about that.
> 
> The only difference was that I fixed the line-wrap problem that you noted in
> your previous Emails. I had found them and resubmitted. There were no content
> changes in the patches and the tree appears to be OK.
> 
> Thanks for the heads-up and sorry for the trouble, Those damned long lines from
> the Realtek driver are a pain.

Yes they are :)

> FYI, the rewritten driver has received a beacon, and the first few parts have
> been submitted to John Linville.

Wonderful, that's great to hear, hopefully we can delete this driver
soon.

thanks,

greg k-h
