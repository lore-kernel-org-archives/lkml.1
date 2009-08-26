Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbZHZVDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbZHZVDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbZHZVDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:03:39 -0400
Received: from kroah.org ([198.145.64.141]:57822 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbZHZVDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:03:38 -0400
Date: Wed, 26 Aug 2009 14:02:02 -0700
From: Greg KH <greg@kroah.com>
To: Mike Mohr <akihana@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: expresscard hotplug not working
Message-ID: <20090826210202.GD8467@kroah.com>
References: <4746469c0908251817u225609bax66ea27261a1ef038@mail.gmail.com>
 <20090826064545.GA7023@kroah.com>
 <4746469c0908261119m6f3edbd3ya6c7f483d434df16@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4746469c0908261119m6f3edbd3ya6c7f483d434df16@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Aug 26, 2009 at 11:19:11AM -0700, Mike Mohr wrote:
> acpiphp fails to load (claiming no such device).  pciehp is loaded but
> dmesg doesn't indicate that any hardware is found by the driver -- it
> only shows a status message stating that the driver is loaded.

Sounds like broken hardware.  I'd bring it up on the linux-pci list,
along with all kernel log messages that might be relevant.

thanks,

greg k-h
