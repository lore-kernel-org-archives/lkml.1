Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbXKSSr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbXKSSr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbXKSSrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:47:07 -0500
Received: from ns.suse.de ([195.135.220.2]:37943 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbXKSSrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:47:04 -0500
Date: Mon, 19 Nov 2007 10:43:46 -0800
From: Greg KH <gregkh@suse.de>
To: David Brownell <david-b@pacbell.net>
Cc: stable@kernel.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, zwane@arm.linux.org.uk, tytso@mit.edu,
       torvalds@linux-foundation.org, stern@rowland.harvard.edu,
       reviews@ml.cw.f00f.org, rdunlap@xenotime.net, mkrufky@linuxtv.org,
       jmforbes@linuxtx.org, dely.l.sy@intel.com, davem@davemloft.net,
       davej@redhat.com, chuckw@quantumlinux.com, cebbert@redhat.com,
       cavokz@gmail.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: Re: [patch 19/26] USB: mutual exclusion for EHCI init and port
	resets
Message-ID: <20071119184346.GA5845@suse.de>
References: <20071119181438.617190424@mini.kroah.org> <20071119181920.GT15425@kroah.com> <20071119184128.E43D423C403@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119184128.E43D423C403@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 10:41:28AM -0800, David Brownell wrote:
> Still needs the following update, IMO ... 

Yes, but that patch isn't in Linus's tree yet, so I can't add it to the
-stable trees.

It's in my queue to send to Linus, but that's not going to happen until
next week at the earliest...

thanks,

greg k-h
