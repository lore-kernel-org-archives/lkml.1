Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZLKQsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZLKQsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbZLKQsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:48:09 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:59289 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbZLKQsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:48:08 -0500
To: device-mapper development <dm-devel@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org, Heinz Diehl <htd@fancy-poultry.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device mapper warnings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <200912091049.12604.borntraeger@de.ibm.com>
	<170fa0d20912091656s31575d0cneaf899e1781bdc16@mail.gmail.com>
	<yq1bpi7vdes.fsf@sermon.lab.mkp.net>
	<200912111028.05512.borntraeger@de.ibm.com>
Date: Fri, 11 Dec 2009 11:47:40 -0500
In-Reply-To: <200912111028.05512.borntraeger@de.ibm.com> (Christian
	Borntraeger's message of "Fri, 11 Dec 2009 10:28:05 +0100")
Message-ID: <yq13a3hv4nn.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4B2277BD.0198:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christian" == Christian Borntraeger <borntraeger@de.ibm.com> writes:

Christian> any news on the final fix? Do you want Heinz and me to verify
Christian> your fix on our systems?

Looking into this issue unearthed an unrelated problem with the topology
stacking algorithm that turns out to be much trickier to fix.  That's
what's taking time.

Since the first bug is simply causing a warning I'm inclined to get
everything fixed up before having Jens queue a fix.  Shouldn't be more
than a day or two before I have all this worked out.

-- 
Martin K. Petersen	Oracle Linux Engineering

