Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZDGRUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZDGRUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZDGRUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:20:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42416 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZDGRUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:20:24 -0400
Message-ID: <49DB8B54.7050402@garzik.org>
Date: Tue, 07 Apr 2009 13:20:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com>
In-Reply-To: <1238683047-13588-4-git-send-email-willy@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> From: David Woodhouse <David.Woodhouse@intel.com>
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> [modified to reduce amount of special casing needed for discard]
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/ide/ide-disk.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 49 insertions(+), 0 deletions(-)

OK, the linux/ata.h portion of TRIM support is now upstream.  This can 
go via Bart's tree.


