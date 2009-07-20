Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbZGTRA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbZGTRA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZGTRA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:00:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33065 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbZGTRA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:00:56 -0400
Date: Mon, 20 Jul 2009 12:59:41 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       virtualization@lists.osdl.org, Hank Janssen <hjanssen@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Sam Ramji <sramji@microsoft.com>, shemminger@linux-foundation.org
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Message-ID: <20090720165941.GA15660@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	virtualization@lists.osdl.org,
	Hank Janssen <hjanssen@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Sam Ramji <sramji@microsoft.com>, shemminger@linux-foundation.org
References: <20090720160025.GA20249@kroah.com> <20090720162810.GA22102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720162810.GA22102@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 09:28:10AM -0700, Greg KH wrote:
 > On Mon, Jul 20, 2009 at 09:00:25AM -0700, Greg Kroah-Hartman wrote:
 > > 
 > > Hi all,
 > > 
 > > I'm happy to announce, that after many months of discussions, Microsoft
 > > has released their Hyper-V Linux drivers under the GPLv2.  Following
 > > this message, will be the patches that add the drivers to the
 > > drivers/staging/ tree, and a whole bunch of cleanups.
 > 
 > Hm, for some reason my scripts to send patches out caused them to get
 > eaten by the very good lkml filters.  (note, it was my fault, not
 > lkml's).
 > 
 > So instead of trying to send them again, and spaming everyone who
 > already got them, you can find them in my staging tree at:
 > 	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/
 > 
 > If anyone wants me to post any of the individual 54 patches to them,
 > please let me know.

Given the numerous cleanup patches that already exist, is there any reason
to not just post the cleaned up drivers ?  It would certainly be more
reviewable than the current pile.

Come to think of it, is there any value in merging the pre-cleaned up
patches ? Why merge 54 patches to mainline when a half dozen will do ?

	Dave

