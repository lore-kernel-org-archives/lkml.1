Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZGAP7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZGAP7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbZGAP6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:58:44 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44576 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbZGAP6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:58:43 -0400
Date: Wed, 1 Jul 2009 16:58:43 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Reduce AACRAID hardware queue size
Message-ID: <20090701155843.GE13837@shadowen.org>
References: <1245756306-29023-1-git-send-email-apw@canonical.com> <1245756306-29023-2-git-send-email-apw@canonical.com> <1245771089.4149.88.camel@mulgrave.site> <20090623160408.GA22716@smurf.noris.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623160408.GA22716@smurf.noris.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 06:04:08PM +0200, Matthias Urlichs wrote:
> Hi,
> 
> James Bottomley:
> > Firstly, Matthias, can you see if on an unmodified aacraid, this fixes
> > the problem for you:
> > 
> > echo 63 > /sys/block/<disk>/queue/max_sectors_kb
> > 
> Thank you, I'll do that tonight.

How did this one work out for you?  I don't think I saw a reply either
way?

-apw
