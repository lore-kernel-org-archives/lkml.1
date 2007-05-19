Return-Path: <linux-kernel-owner+w=401wt.eu-S1765015AbXESWlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765015AbXESWlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762499AbXESWlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:41:35 -0400
Received: from waste.org ([66.93.16.53]:38542 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761983AbXESWle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:41:34 -0400
Date: Sat, 19 May 2007 17:40:28 -0500
From: Matt Mackall <mpm@selenic.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Message-ID: <20070519224028.GO11115@waste.org>
References: <20070519165738.GK11115@waste.org> <200705192024.16812.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705192024.16812.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 08:24:16PM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> On Saturday, 19 May 2007 18:57, Matt Mackall wrote:
> > Starting with 2.6.21-mm2, I'm seeing occassional failures to resume
> > from suspend-to-ram on my Thinkpad R51. The screen will flash as it
> > usually does, then go black and the machine will become totally
> > unresponsive, even to holding down the power button for 30+ seconds.
> > But the hard drive light will occassionally flash, so the machine is
> > clearly not completely dead at this point.
> 
> Does the mainline (as of 2.6.22-rc2) do this?

Dunno. I've triggered it twice since -mm2 was released, never before
that point. -mm1 was fine.

-- 
Mathematics is the supreme nostalgia of our time.
