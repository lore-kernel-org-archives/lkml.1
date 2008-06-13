Return-Path: <linux-kernel-owner+w=401wt.eu-S1761522AbYFMG4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522AbYFMG4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 02:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761448AbYFMG4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 02:56:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58955 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761256AbYFMG4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 02:56:07 -0400
Message-ID: <48521A02.5070301@garzik.org>
Date: Fri, 13 Jun 2008 02:56:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [patch] libata:ahci: enclosure management support (resend)
References: <20080603103355.34c49ef4@appleyard>
In-Reply-To: <20080603103355.34c49ef4@appleyard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Here's a resend of the patch I sent 2 weeks ago, refreshed against
> Andrews kernel.  This is one of many resends since the original 
> patch was sent in January-ish. Could you please review this patch 
> and let me know what you'd like me to change?  I'm happy to change it 
> however you want as long as the feature still functions.
> 
> Thanks,
> Kristen
> 
> Add Enclosure Management support to libata and ahci.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> ---
>  drivers/ata/ahci.c        |  321 +++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/ata/libata-scsi.c |   79 +++++++++++
>  include/linux/libata.h    |   21 +++
>  3 files changed, 419 insertions(+), 2 deletions(-)

applied


