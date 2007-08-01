Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbXHAVEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbXHAVEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbXHAVDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:03:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:49558 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbXHAVDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:03:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OgVAgTP1yWmi/zQnpuWuscCFf9+T2S4LDF5LR/lfhqZSCQaAJPdUH3HML4pOfg3jdy53Z+UPG4BVUfvGqm6HQ0FLNCxsW2OhlHuKDOcv2fBVjULCwrCyK0de2KFG8G2zciZm/TykobSlaf0xArOpOIr0O4iRyMGhWzplFDQHr7U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: [PATCH] fix runtogether printk's in cmd64x IDE driver
Date: Wed, 1 Aug 2007 22:44:29 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <Pine.SOC.4.64.0707292257150.10801@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0707292257150.10801@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708012244.29225.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 July 2007, Meelis Roos wrote:
> Fix a couple of runtogether printks in cmd64x.c IDE driver by adding 
> proper newlines.
> 
> Signed-off-by: Meelis Roos <mroos@linux.ee>

applied
