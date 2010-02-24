Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0BXDkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:40:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:52733 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab0BXDkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:40:03 -0500
Date: Tue, 23 Feb 2010 18:05:44 -0800
From: Greg KH <gregkh@suse.de>
To: Josh Holland <jrh@joshh.co.uk>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@linux.intel.com>,
       Andr? Goddard Rosa <andre.goddard@gmail.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: rar: More style changes to rar_driver.c
Message-ID: <20100224020544.GC13984@suse.de>
References: <1265318585-24236-1-git-send-email-jrh@joshh.co.uk> <1265407106-19937-1-git-send-email-jrh@joshh.co.uk> <20100217224046.GB31557@kroah.com> <20100220113607.GP24380@polaris.joshh.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100220113607.GP24380@polaris.joshh.co.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 11:36:07AM +0000, Josh Holland wrote:
> On Wed, Feb 17, 2010 at 02:40:46PM -0800, Greg KH wrote:
> > On Fri, Feb 05, 2010 at 09:58:26PM +0000, Josh Holland wrote:
> > > Following advice from Krzysztof Halasa, I made a few changes to the
> > > style bits in rar_driver.c
> > 
> > Can you respin both of these patches in 2 days, against the linux-next
> > tree, as the rar driver author has sent in a bunch of "rename these
> > files" type patches, which caused these to not apply anymore.
> How do I do that? I can't see a linux-next branch in my local repo, and
> I'd rather not download a whole new one...
> 
> $ git remote show origin
> * remote origin
>   URL:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>   HEAD branch: master
>   Remote branch:
>     master tracked
>   Local branch configured for 'git pull':
>     master merges with remote master
>   Local ref configured for 'git push':
>     master pushes to master (up to date)

Google for "linux-next FAQ" for how to set this up properly.

thanks,

greg k-h
