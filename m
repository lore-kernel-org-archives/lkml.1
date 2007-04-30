Return-Path: <linux-kernel-owner+w=401wt.eu-S1946852AbXD3WJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946852AbXD3WJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946856AbXD3WJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:09:30 -0400
Received: from waste.org ([66.93.16.53]:52901 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946857AbXD3WJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:09:29 -0400
Date: Mon, 30 Apr 2007 17:07:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Miles Lane <miles.lane@gmail.com>, lollul@wp.pl,
       Helge Hafting <helgehaf@aitel.hist.no>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.22
Message-ID: <20070430220736.GD11115@waste.org>
References: <200704290102.33533.lenb@kernel.org> <200704302203.31757.rjw@sisk.pl> <20070430200524.GA11115@waste.org> <200704302331.43934.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704302331.43934.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 11:31:42PM +0200, Rafael J. Wysocki wrote:

> Can you please do 'echo shutdown > /sys/power/disk' before the hibernation
> and see what happens?

Do I need to reboot for this test? Same behavior without a reboot.

-- 
Mathematics is the supreme nostalgia of our time.
