Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbZGTRR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbZGTRR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZGTRR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:17:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53462 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbZGTRRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:17:25 -0400
Date: Mon, 20 Jul 2009 13:15:23 -0400
From: Dave Jones <davej@redhat.com>
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       Hank Janssen <hjanssen@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Sam Ramji <sramji@microsoft.com>, shemminger@linux-foundation.org
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Message-ID: <20090720171523.GA16129@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Matthias Urlichs <smurf@smurf.noris.de>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	virtualization@lists.osdl.org,
	Hank Janssen <hjanssen@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Sam Ramji <sramji@microsoft.com>, shemminger@linux-foundation.org
References: <20090720160025.GA20249@kroah.com> <20090720162810.GA22102@kroah.com> <20090720165941.GA15660@redhat.com> <20090720170911.GS12833@kiste.smurf.noris.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720170911.GS12833@kiste.smurf.noris.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 07:09:11PM +0200, Matthias Urlichs wrote:
 > Hi,
 > 
 > Dave Jones:
 > > Given the numerous cleanup patches that already exist, is there any reason
 > > to not just post the cleaned up drivers ?  It would certainly be more
 > > reviewable than the current pile.
 > > 
 > Feel free to apply / combinediff these patches before reviewing. :-P
 > 
 > Personally, I don't want to ever see another patch where substantial
 > changes (for some nontrivial value of "substantial") are intermixed
 > with distracting s/\<BOOLEAN\>/bool/g cleanups.

'Substantial changes' doesn't matter when it's an initial submission.
By its nature, it's a substantial change.

	Dave
