Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbYBAWjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbYBAWjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759747AbYBAWhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:37:25 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:18433 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387AbYBAWhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:37:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=KDZQAFScxco8Ecj4x5y9vscOG39C/3iBgV+PXUI1w/cq3+1GJo/tIUCTsrXs70qVtoWHFa4hATbdDxA4FDLZZg8rOdgidsk9zmbri0JTvoSe6+fxGhUYgvVx4niupPQV22NwbPGDC8Moad3/srF/s0buEqrqHTNTc/Zesh2OHvI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] ide/ppc/pmac.c section fixes
Date: Fri, 1 Feb 2008 23:49:14 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080130200320.GI29368@does.not.exist>
In-Reply-To: <20080130200320.GI29368@does.not.exist>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802012349.14449.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008, Adrian Bunk wrote:
> This patch fixes the following section mismatch:
> 
> <--  snip  -->
> 
> ...
> WARNING: vmlinux.o(.text+0x3b641c): Section mismatch in reference from the function .pmac_ide_setup_device() to the function .init.text:.pmac_ide_setup_dma()
> ...
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied

[ thanks for all patches, especially for fixup-after-Bart ones ;) ]
