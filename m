Return-Path: <linux-kernel-owner+w=401wt.eu-S1751639AbZIGH2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbZIGH2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 03:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZIGH2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 03:28:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34234 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbZIGH2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 03:28:31 -0400
Date: Mon, 7 Sep 2009 09:28:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Trisal, Kalhan" <kalhan.trisal@intel.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: Light sensors, unifying current options?
Message-ID: <20090907072826.GB21242@elf.ucw.cz>
References: <4A9FC9D7.20000@cam.ac.uk> <3CA6C6D9F70D314CA34352990B57DA1537B8F7D9@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3CA6C6D9F70D314CA34352990B57DA1537B8F7D9@bgsmsx502.gar.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-09-07 10:56:23, Trisal, Kalhan wrote:
> Jonathan, 
>    What about combo devices, Digital Ambient Light + Proximity Sensor, where will these sensors fit in. I think we need to define all the possible combinations of ALS devices which are currently available. 
> 

I don't see why we should need that. Presenting combined device as two
separate devices to userland is completely ok.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
