Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYCSXN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYCSXN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYCSVkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:40:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58029 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935098AbYCSVk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:40:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: [PATCH 0/3] PM wakeup flags revisited (was: Re: + pm-convert-wakeup-flag-accessors-to-inline-functions-fix.patch added to -mm tree)
Date: Wed, 19 Mar 2008 22:33:54 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>, lenb@kernel.org
References: <200803190315.m2J3FXnK029022@imap1.linux-foundation.org> <20080319114829.bf993b72.akpm@linux-foundation.org> <20080319185755.GA18464@kroah.com>
In-Reply-To: <20080319185755.GA18464@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192233.55313.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of March 2008, Greg KH wrote:
> On Wed, Mar 19, 2008 at 11:48:29AM -0700, Andrew Morton wrote:
> > I'll drop everything, let's start again.
> > 
> > Only how?  umm, please review Greg's driver tree, let us know which patches
> > shoudl be dropped from that then send new ones, I guess.
> 
> Yes, please do, I'm confused as well :)

Please drop pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch 
and apply the following three patches instead.

Thanks,
Rafael

