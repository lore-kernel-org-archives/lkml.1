Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYAQPwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYAQPwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 10:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYAQPwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 10:52:24 -0500
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:22170
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949AbYAQPwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 10:52:23 -0500
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2008 10:52:22 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAFMGj0d8qQM6/2dsb2JhbAAIrg0
X-IronPort-AV: E=Sophos;i="4.24,301,1196607600"; 
   d="scan'208";a="215204194"
Subject: SX8 docs (was: The SX4 challenge)
From: James Andrewartha <jamesa@daa.com.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux RAID list <linux-raid@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <478EA794.8080608@garzik.org>
References: <478EA794.8080608@garzik.org>
Content-Type: text/plain
Organization: Data Analysis Australia
Date: Fri, 18 Jan 2008 00:42:06 +0900
Message-Id: <1200584526.7112.19.camel@zarvora>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-16 at 19:55 -0500, Jeff Garzik wrote:
> Promise just gave permission to post the docs for their PDC20621 (i.e. 
> SX4) hardware:
> http://gkernel.sourceforge.net/specs/promise/pdc20621-pguide-1.2.pdf.bz2
> 
> joining the existing PDC20621 DIMM and PLL docs:
> http://gkernel.sourceforge.net/specs/promise/pdc20621-pguide-dimm-1.6.pdf.bz2
> http://gkernel.sourceforge.net/specs/promise/pdc20621-pguide-pll-ata-timing-1.2.pdf.bz2
> 
> 
> So, the SX4 is now open.  Yay :)  I am hoping to talk Mikael into 
> becoming the sata_sx4 maintainer, and finally integrating my 'new-eh' 
> conversion in libata-dev.git.
> 
> But now is a good time to remind people how lame the sata_sx4 driver 
> software really is -- and I should know, I wrote it.

Hi Jeff,

What are the chances of the SX8 docs being opened? The vendor GPL driver
has bitrotted and the kernel driver offers poor performance or data
corruption. IIRC it's not part of libata but its own block device,
although you were considering porting it to get ATAPI support?

Thanks,

James Andrewartha
