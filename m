Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYAGCIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYAGCIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 21:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYAGCIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 21:08:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:4067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbYAGCIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 21:08:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,251,1196668800"; 
   d="scan'208";a="276255989"
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to
	"unsupported" if wakeup feature isn't supported by a device
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, Olivier Galibert <galibert@pobox.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <200801041820.24819.oliver@neukum.org>
References: <20080104160933.B01D81FBAB5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <Pine.LNX.4.44L0.0801041136490.4078-100000@iolanthe.rowland.org>
	 <20080104165214.GA30672@dspnet.fr.eu.org>
	 <200801041820.24819.oliver@neukum.org>
Content-Type: text/plain
Organization: Intel
Date: Mon, 07 Jan 2008 10:00:46 +0800
Message-Id: <1199671246.3551.12.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-04 at 18:20 +0100, Oliver Neukum wrote:
> Am Freitag, 4. Januar 2008 17:52:14 schrieb Olivier Galibert:
> > On Fri, Jan 04, 2008 at 11:38:29AM -0500, Alan Stern wrote:
> > > How about changing it to say "unavailable"?  That doesn't imply 
> > > permanence.
> > 
> > How about not changing a userland-visible interface gratuitously?
> 
Why not do if we can make it better?
> Very good idea.
> 
> 	Regards
> 		Oliver

