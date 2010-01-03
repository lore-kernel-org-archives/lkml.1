Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068Ab0ACV3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab0ACV3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 16:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872Ab0ACV27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 16:28:59 -0500
Received: from kroah.org ([198.145.64.141]:47983 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab0ACV26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 16:28:58 -0500
Date: Sun, 3 Jan 2010 13:29:13 -0800
From: Greg KH <greg@kroah.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Documentation/feature-removal-schedule.txt to be updated soon?
Message-ID: <20100103212913.GB3220@kroah.com>
References: <alpine.LFD.2.00.1001030652110.6587@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001030652110.6587@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 03, 2010 at 06:54:10AM -0500, Robert P. J. Day wrote:
> 
>   as is my wont, i will mutter quietly about the amount of content in
> the file Documentation/feature-removal-schedule.txt referring to stuff
> that should have been removed ages ago (some of it is dated as far
> back as 2005).
> 
>   is there any plan on bringing that file up to date, and/or deleting
> stuff that's been marked for deletion for years?

Sure, feel free to send patches, and if they are rejected, send a patch
for the feature-removal-schedule.txt file removing the option there.

thanks,

greg k-h
