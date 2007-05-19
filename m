Return-Path: <linux-kernel-owner+w=401wt.eu-S1765128AbXESWji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765128AbXESWji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762011AbXESWjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:39:31 -0400
Received: from waste.org ([66.93.16.53]:38502 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759508AbXESWja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:39:30 -0400
Date: Sat, 19 May 2007 17:38:43 -0500
From: Matt Mackall <mpm@selenic.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Message-ID: <20070519223843.GN11115@waste.org>
References: <20070519165738.GK11115@waste.org> <20070519204504.GA24704@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070519204504.GA24704@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 05:45:04PM -0300, Henrique de Moraes Holschuh wrote:
> On Sat, 19 May 2007, Matt Mackall wrote:
> > usually does, then go black and the machine will become totally
> > unresponsive, even to holding down the power button for 30+ seconds.
> 
> Now, that means either the BIOS or EC have been thrown out of whack,
> otherwise one of the two would have force-powered-off the machine a bit
> after 10s.
> 
> Are you using the latest BIOS and EC firmware available?

No, I've been running the same BIOS without issue for two years.

-- 
Mathematics is the supreme nostalgia of our time.
