Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbXE0PMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbXE0PMc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbXE0PMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:12:23 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:36696 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753701AbXE0PMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:12:22 -0400
Subject: Re: [PATCH 5/5] SCSI/initio conversion to PCI driver API
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <46599DD9.4020408@garzik.org>
References: <20070527145200.GA17017@havoc.gtf.org>
	 <20070527145955.GE17085@havoc.gtf.org>  <46599DD9.4020408@garzik.org>
Content-Type: text/plain
Date: Sun, 27 May 2007 10:12:19 -0500
Message-Id: <1180278739.3711.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-27 at 11:03 -0400, Jeff Garzik wrote:
> Jeff Garzik wrote:
> > Prior simplifications in this patchset now permit a minimal conversion
> > to the new PCI API.
> > 
> > Further improvements and simplifications are certainly possible; those
> > should be presented in a separate patchset.
> > 
> > DO NOT APPLY (yet).  For feedback (and testers?) only.
> 
> 
> This only applies to patch #5.
> 
> Patches 1 through 4 should go upstream, IMO.

Erm, actually, you're treading all over Alan:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=72d39fea9017bbb1407620bf89dfe8d1fb658e35

Could you rebase your patches to scsi-misc-2.6 and resubmit (if there's
anything Alan hasn't covered)?

Thanks,

James


