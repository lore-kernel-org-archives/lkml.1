Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbZLKTFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbZLKTFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 14:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761222AbZLKTFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 14:05:06 -0500
Received: from kroah.org ([198.145.64.141]:60677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761133AbZLKTFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 14:05:04 -0500
Date: Fri, 11 Dec 2009 11:04:30 -0800
From: Greg KH <greg@kroah.com>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Linux <linux-kernel@vger.kernel.org>,
       Linux Input <linux-input@vger.kernel.org>,
       Linux USB <linux-usb@vger.kernel.org>
Subject: Re: Logitech G13 driver + user-space libraries available
Message-ID: <20091211190430.GB22482@kroah.com>
References: <d4690bfe19cee0dc8c5355a684fa7e09.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4690bfe19cee0dc8c5355a684fa7e09.squirrel@intranet.cs.nmsu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 10:24:52AM -0700, Rick L. Vinyard, Jr. wrote:
> Here's a first look at the G13 driver I've been playing around with:
>      git://g13.git.sourceforge.net/gitroot/g13/g13
> 
> I've been building the driver out-of-tree and this is my first (untested)
> shot at moving it in-tree. There are still a number of things to do (and
> clean up) in the driver but it is rather functional.
> 
> I'll test it later today and update the repo as necessary, but I thought
> I'd throw it out there now.

Nice, but sending a patch to review it is best, don't point people at a
random git tree and expect they will look at the code.

Also, please run the driver through the scripts/checkpatch.pl script,
and fix all of the things it reports, before submitting it.

thanks,

greg k-h
