Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbZCEOuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbZCEOuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbZCEOtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:49:53 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:54392 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbZCEOtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:49:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=PqaJa6Tl4AeftYnvnI5qklZoVF2213YyssGoCwEey1YpUmIpqIE3IQyhQKfMx/vz72
         PYc/wVlRd0pa+klUMTq0ThmHu4hGOgDG91WmH91uhd8sw3W813hG2EIPX2KWeBk1Fgcw
         5xWFGDqE+Tf8eygxgnZBuCFTUnU1BQd529/TE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Hannes Eder <hannes@hanneseder.net>
Subject: Re: [PATCH 04/16 v3] NULL noise: drivers/ide/ide-*.c
Date: Thu, 5 Mar 2009 14:47:55 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-next-20090304; KDE/4.2.0; i686; ; )
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
References: <20090302235343.28697.19909.stgit@f10box.hanneseder.net>
In-Reply-To: <20090302235343.28697.19909.stgit@f10box.hanneseder.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903051447.55370.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 March 2009, Hannes Eder wrote:
> Fix this sparse warnings:
>   drivers/ide/ide-disk_proc.c:130:11: warning: Using plain integer as NULL pointer
>   drivers/ide/ide-floppy_proc.c:32:11: warning: Using plain integer as NULL pointer
>   drivers/ide/ide-proc.c:234:11: warning: Using plain integer as NULL pointer
>   drivers/ide/ide-tape.c:2141:11: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

applied
