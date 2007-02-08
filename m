Return-Path: <linux-kernel-owner+w=401wt.eu-S1422943AbXBHHgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422943AbXBHHgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 02:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422936AbXBHHgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 02:36:22 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:55180 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422943AbXBHHgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 02:36:21 -0500
Message-ID: <45CAD2F1.7030705@fr.ibm.com>
Date: Thu, 08 Feb 2007 08:36:17 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm snapshot broken-out-2007-02-06-16-59.tar.gz uploaded
References: <200702070059.l170xPY0002614@shell0.pdx.osdl.net> <45CA0065.80705@fr.ibm.com> <6bffcb0e0702071403v767681edk2179fdb968b57e5a@mail.gmail.com> <20070207141532.9c1ac548.akpm@linux-foundation.org> <6bffcb0e0702071512i2567a2br3a873921b0d3d308@mail.gmail.com>
In-Reply-To: <6bffcb0e0702071512i2567a2br3a873921b0d3d308@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> On 07/02/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>> I copied it to
>> http://userweb.kernel.org/~akpm/broken-out-2007-02-06-16-59.tar.gz but
>> there's really not much point in using it - it's ancient.
> 
> Cedric, here is an updated version
> http://www.stardust.webpages.pl/files/mm-snapshot/mm-snapshot-07-02-07-22-21.tar.bz2
> 
> 
> Without four patches
> 
> #swiotlb-uninlinings.patch
> #git-cryptodev-fixup.patch
> #add-vm_insert_pfn.patch
> #knfsd-fix-a-race-in-closing-nfsd-connections.patch

Thanks !

c.
