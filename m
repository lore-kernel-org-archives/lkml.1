Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbYIOScY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbYIOScY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYIOScF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:32:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:10279 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYIOScD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=F3mytb/OnnIKK2htCBru7/c3PxfG48oJ09FRlq9FcoQe90c8K+TM3kclEiLGdF+vHT
         PuBhwVBFW190LJNAtUflpUAMKjQfhMAKFJ5bCk54Qxsfcmso1hVj4KwvBRIftQ/4neu/
         JrGQxCQyNfcGaOQAscUkJAMunh9z63bveHLVM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 02/10] ide-cd: move cdrom_info.dma to ide_drive_t.dma
Date: Mon, 15 Sep 2008 19:54:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com> <1221392158-3848-3-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1221392158-3848-3-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809151954.28446.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 September 2008 13:35:50 Borislav Petkov wrote:
> There should be no functionality change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
