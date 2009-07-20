Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbZGTRKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbZGTRKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZGTRKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:10:13 -0400
Received: from smurf.noris.de ([192.109.102.42]:32705 "EHLO
	smurf.intern.smurf.noris.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752325AbZGTRKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:10:12 -0400
Date: Mon, 20 Jul 2009 19:09:11 +0200
From: Matthias Urlichs <smurf@smurf.noris.de>
To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       virtualization@lists.osdl.org, Hank Janssen <hjanssen@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Sam Ramji <sramji@microsoft.com>, shemminger@linux-foundation.org
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Message-ID: <20090720170911.GS12833@kiste.smurf.noris.de>
References: <20090720160025.GA20249@kroah.com> <20090720162810.GA22102@kroah.com> <20090720165941.GA15660@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720165941.GA15660@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Smurf-Spam-Score: -2.6 (--)
X-Smurf-Whitelist: +relay_from_hosts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dave Jones:
> Given the numerous cleanup patches that already exist, is there any reason
> to not just post the cleaned up drivers ?  It would certainly be more
> reviewable than the current pile.
> 
Feel free to apply / combinediff these patches before reviewing. :-P

Personally, I don't want to ever see another patch where substantial
changes (for some nontrivial value of "substantial") are intermixed
with distracting s/\<BOOLEAN\>/bool/g cleanups.

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
v4sw7$Yhw6+8ln7ma7u7L!wl7DUi2e6t3TMWb8HAGen6g3a4s6Mr1p-3/-6 hackerkey.com
 - -
You can never do merely one thing.
					-- Garrett Hardin
