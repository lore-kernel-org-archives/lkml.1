Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbZGTRW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbZGTRW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZGTRWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:22:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53635 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbZGTRWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:22:23 -0400
Date: Mon, 20 Jul 2009 13:22:15 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       virtualization@lists.osdl.org, Hank Janssen <hjanssen@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Sam Ramji <sramji@microsoft.com>, shemminger@linux-foundation.org
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Message-ID: <20090720172214.GB16129@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	virtualization@lists.osdl.org,
	Hank Janssen <hjanssen@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Sam Ramji <sramji@microsoft.com>, shemminger@linux-foundation.org
References: <20090720160025.GA20249@kroah.com> <20090720162810.GA22102@kroah.com> <20090720165941.GA15660@redhat.com> <20090720170345.GA23990@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720170345.GA23990@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 10:03:45AM -0700, Greg KH wrote:
 > The code still needs lots of cleanup, and review, as is evident by the
 > TODO file.  It looks like the patches did get sent to the driver-devel
 > and virtualization lists, so you can see them there if you want to.
 > 
 > But if you want, I can post the 4 individual drivers as of right now,
 > what they will show up in the linux-next tree tomorrow if you want me
 > to.

I already patched a copy of all 54 patches while I was waiting.
(For those playing along at home: http://codemonkey.org.uk/junk/hv.diff)

	Dave

