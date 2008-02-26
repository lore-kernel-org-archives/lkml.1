Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbYBZW1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbYBZW1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765381AbYBZWXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:23:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:27382 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764926AbYBZWXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=jDFLzDWTDEkSlbf+tWnzk1uXtO00zNvO78QXbFGPkfsaOAWU/oBlw1J0zp4m1DEgkujEFZXy8JZm2UpBfb9/neLeg0+IVHAOvX9Tr9vuSxVBJjS+yaVWfP8GZO3y0pEKR7sFGVcdr+gJi+UiPwxoRd+KF8d+xz0z18JvC4trsyo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Subject: Re: [PATCH 0/3] Various IDE coding style fixes
Date: Tue, 26 Feb 2008 23:25:06 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>,
       Borislav Petkov <petkovbb@gmail.com>
References: <20080224220932.4098443e@paolo-desktop>
In-Reply-To: <20080224220932.4098443e@paolo-desktop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802262325.06886.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 February 2008, Paolo Ciarrocchi wrote:
> Hi Bart,
> three more patches, all are compile tested and against yesterday linux-next
> 
> "IDE: Replace __FUNCTION__ with __func__" depends 
> on "IDE: Coding Style fixes to drivers/ide/ide-cd.c"
> 
> 
> Paolo Ciarrocchi (3):
>       IDE: Coding Style fixes to drivers/ide/ide-cd.c
>       IDE: Replace __FUNCTION__ with __func__
>       IDE: Coding Style fixes to drivers/ide/pci/cy82c693.c
> 
>  drivers/ide/ide-cd.c       |  259 +++++++++++++++++++++++---------------------
>  drivers/ide/pci/cy82c693.c |   74 +++++++-------
>  2 files changed, 171 insertions(+), 162 deletions(-)

all patches applied (+md5sum checked)
