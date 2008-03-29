Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYC2Sq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYC2Sq3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYC2SqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:46:21 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:41503 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYC2SqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bklJaefb6K3F6mVR+3ILbIfEC2dBVrVDyEW3DvebdFZOxJ6nHdvr+G9Qk58yCHALTiqLOyMw7SDqRSahQrkPAAeiR0mppWhfGN8Du2FH74T+xv+IMSCL23yQW/4hnp1d1m883tQ7SD3MWfdoNJPSXb2sosVTa6ONya7cnXc4RFs=
Subject: Re: [PATCH] NULL noise: drivers/media
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <E1JfRPu-0002Xh-I3@ZenIV.linux.org.uk>
References: <E1JfRPu-0002Xh-I3@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sat, 29 Mar 2008 11:46:25 -0700
Message-Id: <1206816385.6543.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-29 at 03:07 +0000, Al Viro wrote:
> ---
>  drivers/media/common/saa7146_core.c          |   13 +++++--------
>  drivers/media/common/saa7146_fops.c          |    2 +-
>  drivers/media/dvb/dvb-core/dvb_net.c         |    4 ++--
>  drivers/media/video/adv7170.c                |    2 +-
>  drivers/media/video/adv7175.c                |    2 +-
>  drivers/media/video/bt819.c                  |    2 +-
>  drivers/media/video/bt856.c                  |    2 +-
>  drivers/media/video/dpc7146.c                |    2 +-
>  drivers/media/video/mt20xx.c                 |    2 +-
>  drivers/media/video/mxb.c                    |    5 ++---
>  drivers/media/video/pvrusb2/pvrusb2-ctrl.c   |    4 ++--
>  drivers/media/video/pvrusb2/pvrusb2-hdw.c    |    6 +++---
>  drivers/media/video/pvrusb2/pvrusb2-io.c     |    2 +-
>  drivers/media/video/pvrusb2/pvrusb2-ioread.c |    2 +-
>  drivers/media/video/pwc/pwc-if.c             |    7 +++----
>  drivers/media/video/saa7110.c                |    4 ++--
>  drivers/media/video/saa7111.c                |    2 +-
>  drivers/media/video/saa7114.c                |    2 +-
>  drivers/media/video/saa7185.c                |    2 +-
>  drivers/media/video/tda9840.c                |    2 +-
>  drivers/media/video/tea6415c.c               |    2 +-
>  drivers/media/video/tea6420.c                |    2 +-
>  drivers/media/video/tvp5150.c                |    4 ++--
>  drivers/media/video/zoran_driver.c           |    2 +-
>  24 files changed, 37 insertions(+), 42 deletions(-)
> 

Not duplicated in any of my patches, please apply.

Harvey

