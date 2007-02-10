Return-Path: <linux-kernel-owner+w=401wt.eu-S1751194AbXBJQoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbXBJQoy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 11:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbXBJQox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 11:44:53 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4779 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbXBJQov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 11:44:51 -0500
Date: Sat, 10 Feb 2007 11:39:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Theodore Tso <tytso@mit.edu>, James Ketrenos <jketreno@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Message-ID: <20070210163933.GA17140@tuxdriver.com>
References: <45CCE3CA.4050904@linux.intel.com> <20070210162254.GC25607@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210162254.GC25607@thunk.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 11:22:54AM -0500, Theodore Tso wrote:
> On Fri, Feb 09, 2007 at 01:12:42PM -0800, James Ketrenos wrote:
> > Please hold all questions until I am done with this email.  Thank you.
> > 
> > We are pleased to announce the availability of a new driver for the 
> > Intel PRO/Wireless 3945ABG Network Connection adapter.  This new driver 
> > uses the new d80211 subsystem previously only available as part of the 
> > wireless-dev tree.
> 
> Very cool!  Is it likely that d80211 and iwlwifi will be pushed into
> mainline in time for 2.6.21?

Hmmm...I think we need to spend a cycle or so in -mm.  2.6.22 seems
more likely for mainline.

John
-- 
John W. Linville
linville@tuxdriver.com
