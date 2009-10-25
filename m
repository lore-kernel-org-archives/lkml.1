Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbZJYRSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbZJYRSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 13:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZJYRSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 13:18:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53590 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbZJYRSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 13:18:41 -0400
Date: Sun, 25 Oct 2009 17:18:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>, tony@atomide.com,
       alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20091025171838.GA5141@sirena.org.uk>
References: <1256207208-25010-1-git-send-email-peter.ujfalusi@nokia.com>
 <1256207208-25010-2-git-send-email-peter.ujfalusi@nokia.com>
 <20091023140703.GA3718@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023140703.GA3718@sortiz.org>
X-Cookie: Flame on!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH 1/4 v2] MFD: twl4030: add twl4030_codec
 MFD as a new child to the core
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 04:07:05PM +0200, Samuel Ortiz wrote:

> As agreed, Mark is taking this one. So:
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Applied all, if there's a merge problem with the MFD code then there's a
twl4030-mfd branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git

which I'm happy for you to merge if it makes life easier.  Due to other
changes the patches end up depending on (just textually I think) there's
a big raft of other stuff in there too, sadly.
