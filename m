Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0BTLpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 06:45:24 -0500
Received: from polaris.joshh.co.uk ([212.13.195.18]:52263 "EHLO
	polaris.joshh.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab0BTLpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 06:45:23 -0500
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Feb 2010 06:45:23 EST
Date: Sat, 20 Feb 2010 11:36:07 +0000
From: Josh Holland <jrh@joshh.co.uk>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       devel@driverdevv.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: rar: More style changes to rar_driver.c
Message-ID: <20100220113607.GP24380@polaris.joshh.co.uk>
References: <1265318585-24236-1-git-send-email-jrh@joshh.co.uk> <1265407106-19937-1-git-send-email-jrh@joshh.co.uk> <20100217224046.GB31557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217224046.GB31557@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 02:40:46PM -0800, Greg KH wrote:
> On Fri, Feb 05, 2010 at 09:58:26PM +0000, Josh Holland wrote:
> > Following advice from Krzysztof Halasa, I made a few changes to the
> > style bits in rar_driver.c
> 
> Can you respin both of these patches in 2 days, against the linux-next
> tree, as the rar driver author has sent in a bunch of "rename these
> files" type patches, which caused these to not apply anymore.
How do I do that? I can't see a linux-next branch in my local repo, and
I'd rather not download a whole new one...

$ git remote show origin
* remote origin
  URL:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
  HEAD branch: master
  Remote branch:
    master tracked
  Local branch configured for 'git pull':
    master merges with remote master
  Local ref configured for 'git push':
    master pushes to master (up to date)


-- 
Josh "dutchie" Holland <jrh@joshh.co.uk>
http://www.joshh.co.uk/
http://twitter.com/jshholland
http://identi.ca/jshholland
