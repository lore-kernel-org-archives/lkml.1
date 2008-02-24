Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbYBXQcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbYBXQcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYBXQcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:32:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:30810 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbYBXQcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:32:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=hef7EIeQQ/yxMbzjCGVtCjplxmLYx1ys0tYUd9Uu9LEawIWe7epLB74PDupVZNEjXmeCN0vaSgfW019okrGe3vNn/87hk2+unxYywjgp4i6doiAbIgXbDsnvT1EV/UsczAXB3pKb/RuYAxoGzVdCi7Y+cO1HLUddEGSdmG6C6FQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Subject: Re: [PATCH 0/6] IDE: new series of Coding Style Fixes
Date: Sun, 24 Feb 2008 17:38:57 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
References: <20080223183812.5af6d36d@paolo-desktop>
In-Reply-To: <20080223183812.5af6d36d@paolo-desktop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802241738.57839.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 23 February 2008, Paolo Ciarrocchi wrote:
> Bart,
> here is a new series of patches that remove some errors
> and warnings reported by checkpatch.pl from the IDE subsystem.
> 
> All the patches have been compile tested and are against this morning (CET time :-)
> linux-next
> 
> Paolo Ciarrocchi (6):
>       IDE: Coding Style fixes to drivers/ide/pci/opti621.c
>       IDE: Coding Style fixes to drivers/ide/legacy/hd.c
>       IDE: Coding Style fixes to drivers/ide/legacy/ali14xx.c
>       IDE: Coding Style fixes to drivers/ide/pci/it8213.c

the above change (patch 4/6) seems to be m.i.a. ?

>       IDE: Coding Style fixes to drivers/ide/ide-floppy.c
>       IDE: Coding Style fixes to drivers/ide/pci/cmd640.c
> 
>  drivers/ide/ide-floppy.c     |    4 +-
>  drivers/ide/legacy/ali14xx.c |   11 +++--
>  drivers/ide/legacy/hd.c      |   79 ++++++++++++++++++------------------
>  drivers/ide/pci/cmd640.c     |   90 +++++++++++++++++++++---------------------
>  drivers/ide/pci/it8213.c     |    9 ++--
>  drivers/ide/pci/opti621.c    |   50 ++++++++++++------------
>  6 files changed, 122 insertions(+), 121 deletions(-)

I applied all the rest (some with minor fixes).

Thanks,
Bart
