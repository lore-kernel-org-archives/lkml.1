Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbXBJQXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbXBJQXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 11:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789AbXBJQXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 11:23:00 -0500
Received: from THUNK.ORG ([69.25.196.29]:57680 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932772AbXBJQW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 11:22:59 -0500
Date: Sat, 10 Feb 2007 11:22:54 -0500
From: Theodore Tso <tytso@mit.edu>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Message-ID: <20070210162254.GC25607@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	James Ketrenos <jketreno@linux.intel.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
References: <45CCE3CA.4050904@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CCE3CA.4050904@linux.intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 01:12:42PM -0800, James Ketrenos wrote:
> Please hold all questions until I am done with this email.  Thank you.
> 
> We are pleased to announce the availability of a new driver for the 
> Intel PRO/Wireless 3945ABG Network Connection adapter.  This new driver 
> uses the new d80211 subsystem previously only available as part of the 
> wireless-dev tree.

Very cool!  Is it likely that d80211 and iwlwifi will be pushed into
mainline in time for 2.6.21?

Regards,

						- Ted
