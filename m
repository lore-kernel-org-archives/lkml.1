Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZCSTFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZCSTFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbZCSTFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:05:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47013 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZCSTFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:05:39 -0400
Date: Thu, 19 Mar 2009 19:05:30 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <greg@kroah.com>
Cc: Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>,
       David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core changes
Message-ID: <20090319190530.GA22248@srcf.ucam.org>
References: <20090319040809.GA29249@kroah.com> <6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com> <20090319162719.GB32078@kroah.com> <20090319185338.GA21890@srcf.ucam.org> <20090319190254.GA31771@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319190254.GA31771@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 12:02:54PM -0700, Greg KH wrote:
> On Thu, Mar 19, 2009 at 06:53:38PM +0000, Matthew Garrett wrote:
> > On Thu, Mar 19, 2009 at 09:27:19AM -0700, Greg KH wrote:
> > 
> > > But how do I get my laptop that I currently have right now up and
> > > running properly with linux in a better-than-800x600-framebuffer mode?
> > 
> > You don't, because there's no working X driver.
> 
> Um, no, I have one right here, seems to work ok.  Richard pointed out
> the public git tree for it.

With current X? If that's been fixed up recently then it's a definite 
improvement, but last I checked it only built against old X servers.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
