Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZBRTFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZBRTFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZBRTF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:05:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:29180 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZBRTF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:05:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=PXraAf63m9RQnIm/XE3XHlKMiZbNnKiOH5xG7Il1LjDCHw/VlSUEh/m5LLWLl9QyVw
         9Pc1WZns+LsyvR2SAyc1iJLRLhxgCeVp/010rmw1Ks7TusckNkDrYq1yLGU6nKFmfsF5
         3wwnKi+R4SMSTDS9BrnlLFxJ5r0Ct6PRg5dQg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for February 12 (ide)
Date: Wed, 18 Feb 2009 19:58:18 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090218; KDE/4.2.0; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
References: <20090212194408.ff7489c1.sfr@canb.auug.org.au> <200902171519.27031.bzolnier@gmail.com> <499C42A8.7060003@oracle.com>
In-Reply-To: <499C42A8.7060003@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181958.18733.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009, Randy Dunlap wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 12 February 2009, Randy Dunlap wrote:
> >> Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20090211:
> >>
> >> When
> >> # CONFIG_BLK_DEV_IDEDMA is not set
> >>
> >> linux-next-20090212/drivers/ide/ide-taskfile.c:108: error: 'ide_dma_intr' undeclared (first use in this function)
> > 
> > Thanks for spotting this, I fixed it in the revised patch:
> 
> Hi Bart,
> 
> Have you pushed this patch yet?
> 
> linux-next (20090218) is still getting this IDE build error.

I got caught by some other things yesterday so this was pushed
out today.  Sorry about confusion/delay.

Thanks,
Bart
