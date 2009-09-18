Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbZIRRFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbZIRRFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbZIRRFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:05:20 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:53980 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbZIRRFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:05:18 -0400
Date: Fri, 18 Sep 2009 18:05:17 +0100
From: Chris Webb <chris@arachsys.com>
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <teheo@suse.de>, linux-scsi@vger.kernel.org,
       Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
Message-ID: <20090918170517.GI2141@arachsys.com>
References: <4AADF3C4.5060004@kernel.org>
 <4AADF471.2020801@suse.de>
 <4AAE3B9A.2060306@rtr.ca>
 <4AAE3F86.8090804@suse.de>
 <4AAE524C.2030401@rtr.ca>
 <20090916231921.GL1924@arachsys.com>
 <4AB239C8.2020203@rtr.ca>
 <4AB25736.1060601@suse.de>
 <4AB260CA.8040308@rtr.ca>
 <4AB2610F.8010904@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB2610F.8010904@rtr.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord <liml@rtr.ca> writes:

> Speaking of which..
> 
> Chris:  I wonder if the errors will also vanish in your situation
> by disabling the onboard write-caches in the drives ?
> 
> Eg.  hdparm -W0 /dev/sd?

Hi Mark. I've got a test machine on its way at the moment, so I'll make sure
I check this one out on it too.

Cheers,

Chris.
