Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYCVWzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYCVWzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbYCVWzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:55:46 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:34696 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbYCVWzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:55:46 -0400
Date: Sat, 22 Mar 2008 23:55:35 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, xfs-masters@oss.sgi.com
Subject: Re: 2.6.25-rc6: kernel BUG at fs/sysfs/file.c:89
In-Reply-To: <20080322151339.adb146bd.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.00.0803222350550.6948@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803212319130.17137@sheep.housecafe.de> <200803220226.35552.rjw@sisk.pl> <20080321222606.16407d74.akpm@linux-foundation.org> <alpine.DEB.1.00.0803221942050.4470@sheep.housecafe.de> <alpine.DEB.1.00.0803222128570.6948@sheep.housecafe.de>
 <20080322151339.adb146bd.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Andrew Morton wrote:
> That's an XFS bug.
> To clarify, I believe you are running
>
> 	2.6.25-rc6
> plus	http://lkml.org/lkml/2008/3/22/8

Yes, Neil's patch you posted in this message.

> plus	some dm-crypt patch?

The dm-crypt patch is http://lkml.org/lkml/2008/3/17/214

Thanks,
Christian.
-- 
BOFH excuse #93:

Feature not yet implemented
