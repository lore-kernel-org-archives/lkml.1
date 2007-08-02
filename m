Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbXHBFyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbXHBFyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 01:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXHBFyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 01:54:03 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:16202 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbXHBFyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 01:54:01 -0400
Date: Thu, 2 Aug 2007 08:53:39 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jon Mason <jdmason@kudzu.us>,
       discuss@x86-64.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Removal of duplicated include arch/x86_64/kernel/pci-calgary.c
Message-ID: <20070802055338.GB7146@rhun.ibm.com>
References: <46B0C88B.4020905@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B0C88B.4020905@googlemail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 07:53:15PM +0200, Michal Piotrowski wrote:
> Hi,
> 
> There is no need to include linux/init.h twice

Thanks, looks good. Will be pushed for 2.6.24.

Cheers,
Muli
