Return-Path: <linux-kernel-owner+w=401wt.eu-S933933AbXHVWju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933AbXHVWju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763434AbXHVWjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:39:41 -0400
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:3525 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762339AbXHVWjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:39:40 -0400
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 18:39:40 EDT
Message-ID: <46CCB8BA.6060007@superbug.demon.co.uk>
Date: Wed, 22 Aug 2007 23:29:14 +0100
From: James Courtier-Dutton <James@superbug.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20070804)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <46CCB088.8070606@goop.org> <46CCB56F.8090308@superbug.co.uk> <20070822222036.GD3672@sequoia.sous-sol.org>
In-Reply-To: <20070822222036.GD3672@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * James Courtier-Dutton (James@superbug.co.uk) wrote:
>> If one could directly expose a device to the guest, this feature could
>> be extremely useful for me.
>> Is it possible? How would it manage to handle the DMA bus mastering?
> 
> Yes it's possible (Xen supports pci pass through).  Without an IOMMU
> (like Intel VT-d or AMD IOMMU) it's not DMA safe.
> 
> thanks,
> -chris

Ok, so I need to get a new CPU like the Intel Core Duo that has VT
features? I have an old Pentium 4 at the moment, without any VT features.

Kind Regards

James


