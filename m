Return-Path: <linux-kernel-owner+w=401wt.eu-S2992942AbXBQRck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992942AbXBQRck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992944AbXBQRck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:32:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:40298 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992942AbXBQRcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:32:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qh3ULyzSAn1fz2td6+R+qQhUt5Ptrcti2+dRs3mHCezELhSj/BAihy9sodjJhoGcZr6iyAnF8wwEf6jjFicHa+Zf+ESjQW1W7FnNAop29VIW+48jt8spiNA2thqnomZD30XgstSRjDebOYb4pLRLlQqLMILmH6ThtfyN54hRe2w=
Message-ID: <6bffcb0e0702170932r1a4264f6x5d93a8a5126819db@mail.gmail.com>
Date: Sat, 17 Feb 2007 18:32:35 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: PS3 frame buffer Kconfig problem (was: mm snapshot broken-out-2007-02-17-03-25.tar.gz uploaded)
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Geoff Levand" <geoffrey.levand@am.sony.com>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> The mm snapshot broken-out-2007-02-17-03-25.tar.gz has been uploaded to
>
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-17-03-25.tar.gz
>
> It contains the following patches against 2.6.20:

drivers/video/Kconfig:1624:warning: 'select' used by config symbol
'FB_PS3' refer to undefined symbol 'PS3_PS3AV'

BTW.

Please add email address.

  *  linux/drivers/video/ps3fb.c -- PS3 GPU frame buffer device
 *
 *      Copyright (C) 2006 Sony Computer Entertainment Inc.
 *      Copyright 2006, 2007 Sony Corporation
 *
 *  This file is based on :
 *
  *  linux/drivers/video/vfb.c -- Virtual frame buffer device
 *
 *      Copyright (C) 2002 James Simmons
 *
  *      Copyright (C) 1997 Geert Uytterhoeven

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
