Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbXKOUxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbXKOUxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763370AbXKOUxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:53:03 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:18511 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbXKOUxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:53:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tcIwaCH5ibtW+/x2e472j/z4t4Dx7CdxQ1wQvWB+7PCI2K+ETMJcD++TJBFEXTZGo3adombPHbtXznmHwGUTg92r/j7lN0vm5VTf/jY4LIx3CnXml4XsNSYf6B7eAPaueuoGJ3IczEvcDvJvJ7EEX+N8SP35n6HKUUeXdyIAoC4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [PATCH] sis5513.c: Add Packard Bell EasyNote K5305 to laptops
Date: Thu, 15 Nov 2007 20:28:06 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <473A0A9B.5000104@googlemail.com>
In-Reply-To: <473A0A9B.5000104@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711152028.07552.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, Gabriel C wrote:
> Hi,
> 
> With newer kernels HDD in my old laptop is limited to UDMA 33.
> With this patch I get UDMA 100 again.
> 
> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

applied
