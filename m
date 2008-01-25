Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYAYEbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYAYEbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 23:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYAYEa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 23:30:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:39316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbYAYEa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 23:30:58 -0500
Date: Thu, 24 Jan 2008 20:33:42 -0800
From: Greg KH <gregkh@suse.de>
To: Shane Huang <Shane.Huang@amd.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] PCI: modify SB700 SATA MSI quirk
Message-ID: <20080125043342.GA13458@suse.de>
References: <5CAB7B5D6F8AB84AA868A46B47A507055D8C1D@sshaexmb1.amd.com> <B90463BC30D2E446BA423D888DC85E501BF78E@sshaexmb1.amd.com> <B90463BC30D2E446BA423D888DC85E501BF796@sshaexmb1.amd.com> <B90463BC30D2E446BA423D888DC85E501BF8F0@sshaexmb1.amd.com> <4799591B.5090905@gmail.com> <B90463BC30D2E446BA423D888DC85E501BF905@sshaexmb1.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B90463BC30D2E446BA423D888DC85E501BF905@sshaexmb1.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 11:48:29AM +0800, Shane Huang wrote:
> Hi Tejun:
> 
> 
> > You need to merge the above two messages into one patch description.
> > 
> > After S-O-B, you can put --- and between it and the patch 
> > body, you can say things which you wanna mention but don't 
> > think should be included in commit message.
> 
> OK, I'll have to submit another update patch later.

I recommend running the scripts/checkpatch.pl script on any proposed
patches like this before you send them.  It will find a lot of these
problems for you :)

thanks,

greg k-h
