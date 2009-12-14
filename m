Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbZLNTtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbZLNTtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbZLNTtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:49:09 -0500
Received: from kroah.org ([198.145.64.141]:45477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321AbZLNTtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:49:07 -0500
Date: Mon, 14 Dec 2009 11:48:40 -0800
From: Greg KH <greg@kroah.com>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Linux <linux-kernel@vger.kernel.org>,
       Linux Input <linux-input@vger.kernel.org>,
       Linux USB <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] Logitech G13 driver against torvalds/linux-2.6.git
Message-ID: <20091214194840.GA7033@kroah.com>
References: <376bcd26469b6af1d9dda57fd9a1de19.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <376bcd26469b6af1d9dda57fd9a1de19.squirrel@intranet.cs.nmsu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Great first cut, but please:
	- your patch was linewrapped, please fix your email client to
	  not do that.
	- You did not provide a signed-off-by: line as required by the
	  file Documentation/SubmittingPatches
	- You did not provide a good changelog entry in the body of the
	  email explaining what this patch is, and what it does.
	- you did not cc: the HID maintainer, who is the proper person
	  to apply this patch.  Try using the script,
	  scripts/get_maintainer.pl to figure out who to send patches
	  to.
	- Can you run your patch through the scripts/checkpatch.pl
	  script and fix the errors and warnings it reports?  It would
	  have caught many of the above mentioned things.

Care to try again?

thanks,

greg k-h
