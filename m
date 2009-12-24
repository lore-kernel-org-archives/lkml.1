Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZLXBC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZLXBC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 20:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZLXBC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 20:02:58 -0500
Received: from kroah.org ([198.145.64.141]:49328 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbZLXBC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 20:02:57 -0500
Date: Wed, 23 Dec 2009 16:56:54 -0800
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu
Subject: Re: [PATCH 0/37] kgdb, kdb and atomic kernel modesetting series
Message-ID: <20091224005654.GA28950@kroah.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 03:19:13PM -0600, Jason Wessel wrote:
> Back in May 2009 an initial kdb prototype was posted to lkml as an RFC
> to see if there was sufficient interest to merge kdb and kgdb together.
> 
> There was enough interest to continue on with the project, and it is
> now in a state where further work can occur to review, and hopefully
> merge the code into a future kernel.

Very cool work, nice job.

> The code included in this series does not include any of the USB code
> referenced in the presentation.

I'm guessing that is going to happen sometime later after the main stuff
is merged in?

thanks,

greg k-h
