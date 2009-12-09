Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbZLIVZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbZLIVZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbZLIVZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:25:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53551 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbZLIVZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:25:11 -0500
Date: Wed, 9 Dec 2009 22:25:16 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device
 mapper warnings
Message-ID: <20091209212516.GA6206@fancy-poultry.org>
References: <200912091049.12604.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912091049.12604.borntraeger@de.ibm.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0x3FAF957D
X-OpenPGP-Fingerprint: 0BAE BB83 8B8A 3DE4 08F3  CEB9 DA0F CCBB 3FAF 957D
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20091108 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX1+dyfc43vsSr+BdTk7tNr/4z6azGR2prypKLYH
 aclDtUOeHEmOjy8Ac7Gcqkw0JpZx65bIx4yzO8DRy1Ak6DT4MK
 /KPM9LfZzP+d0t6W9aDuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.12.2009, Christian Borntraeger wrote: 

> with todays git I got a huge amount of warnings for device mapper:
> device-mapper: uevent: version 1.0.3                                                                              
> device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com                                  
> device-mapper: table: 252:0: target device dasdf1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=196608                                                                                
[...]
 
> The same devices produce no warning with a 2.6.32 vanilla kernel.

I have exactly the same here...

