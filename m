Return-Path: <linux-kernel-owner+w=401wt.eu-S1751637AbZJWEbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbZJWEbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 00:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZJWEbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 00:31:44 -0400
Received: from kroah.org ([198.145.64.141]:45487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZJWEbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 00:31:36 -0400
Date: Thu, 22 Oct 2009 21:29:35 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alex Chiang <achiang@hp.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [PATCH 0/7] Documentation: document /sys/devices/system/cpu/
Message-ID: <20091023042935.GD26358@kroah.com>
References: <20091022033506.13399.90799.stgit@bob.kio> <20091022144530.d105c87f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022144530.d105c87f.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 02:45:30PM -0700, Randy Dunlap wrote:
> On Wed, 21 Oct 2009 21:45:10 -0600 Alex Chiang wrote:
> 
> > Hi Greg, Randy,
> > 
> > Not sure who actually maintains Documentation/ABI/; if it's not either of
> > y'all then please point me at the correct maintainer.
> > 
> > Anyhow, I was proposing some patches to enhance the NUMA sysfs interface:
> > 
> > 	http://thread.gmane.org/gmane.linux.kernel.mm/40084/
> 
> Greg does, but he's in Japan or traveling this week...

Yeah, I'm still in Japan.  I'll get to reviewing them next week, sorry
for the delay.

thanks,

greg k-h
