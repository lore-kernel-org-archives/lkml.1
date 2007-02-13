Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXBNAAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXBNAAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbXBNAAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:00:51 -0500
Received: from mga06.intel.com ([134.134.136.21]:5859 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932077AbXBNAAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:00:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,164,1170662400"; 
   d="scan'208"; a="196437547:sNHT30193681"
Message-ID: <45D24740.3070804@linux.intel.com>
Date: Tue, 13 Feb 2007 15:18:24 -0800
From: James Ketrenos <jketreno@linux.intel.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
References: <45CCE3CA.4050904@linux.intel.com>	 <20070213181313.GA5350@ucw.cz> <1171391771.10344.93.camel@johannes.berg>
In-Reply-To: <1171391771.10344.93.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> On Tue, 2007-02-13 at 18:13 +0000, Pavel Machek wrote:
> 
>> Yes... is there merged .git tree somewhere? I downloaded iwl git tree,
>> but it did not contain d80211 stack. I'm now downloading wireless-dev
>> git tree...
> 
> I would expect Intel to post patches some time soon to get into
> wireless-dev.
> 
> johannes

Some of the patches contained in the d80211-1.0.1 'pending/' directory 
have already been submitted to netdev in the past.  The rest will be 
submitted soon (I would have liked them to have been submitted a few 
weeks back, but that slipped through my task list)

The d80211 packages I've pushed to date haven't done a very good job of 
accounting regarding the pending/ directory.  Those were the patches our 
team here had been working with internally, and I wanted to get them out 
to the users ASAP.  I'm working to get better descriptions added to the 
headers of those patches, as well as adding a status line indicating 
when the patches were submitted to the mailing lists for discussion.

The goal is to only include patches in the d80211 tarballs which have 
been submitted for eventual in-tree inclusion.

James
