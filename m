Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZIFF21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZIFF21 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 01:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZIFF20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 01:28:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52473 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZIFF2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 01:28:25 -0400
Date: Sun, 6 Sep 2009 07:28:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       swetland@google.com
Subject: Re: Staging tree status for the .32 kernel merge
Message-ID: <20090906052819.GE1324@ucw.cz>
References: <20090903041429.GA29875@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903041429.GA29875@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> 	  Note, Pavel has been adding some of the Dream hardware
> 	  drivers, which are separate from the core Android drivers.  I
> 	  have no objection to those, but they should work to get merged
> 	  to their "correct" places in the tree in another release or
> 	  so.

Well, some of those drivers should be moderately easy (touchscreen),
but some (camera) will take longer than that. For example camera --
contains _lots_ of code, and uses obsolete v4l api.

Plus, I really need to get recent kernel to boot and then get arch/arm
pieces merged....

So next release is a bit optimistics, but I'm (slowly) working on it.
 

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
