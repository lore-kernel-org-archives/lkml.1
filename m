Return-Path: <linux-kernel-owner+w=401wt.eu-S935437AbXGZRwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935437AbXGZRwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933872AbXGZRvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:51:52 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:37129 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933682AbXGZRvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:51:50 -0400
Date: Thu, 26 Jul 2007 20:51:48 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Jeff Garzik <jeff@garzik.org>
cc: James Bottomley <James.Bottomley@SteelEye.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] Remove libsas PCI dependencies
In-Reply-To: <46A8DE10.8030108@garzik.org>
Message-ID: <Pine.SOC.4.64.0707262050030.1921@math.ut.ee>
References: <Pine.SOC.4.64.0707261129220.17385@math.ut.ee>  <46A867AB.7050007@garzik.org>
 <1185454007.3501.34.camel@localhost.localdomain> <46A8A185.7010609@garzik.org>
 <Pine.SOC.4.64.0707262030090.1921@math.ut.ee> <46A8DE10.8030108@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Compiles fine, unfortunately I can not test kernels on this machine since I
> > have yet to dig out the reason my kernels do not boot.
> 
> That's about the best we can ask for :)  Thanks.  I'm pretty sure you do not
> have any SAS hardware in your sparc32...

Nope, this is a differnet computer - SBus-only Ultra 1 with sparc64 
architecture. The test I meant to do but could't was to load the libsas 
module.

-- 
Meelis Roos (mroos@linux.ee)
