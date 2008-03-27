Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYC0IWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYC0IWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYC0IVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:21:54 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:50687 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbYC0IVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:21:52 -0400
Date: Thu, 27 Mar 2008 09:21:40 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Alasdair G Kergon <agk@redhat.com>
cc: Chr <chunkeey@web.de>, Milan Broz <mbroz@redhat.com>,
       David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, dm-devel@redhat.com, dm-crypt@saout.de,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120
 seconds
In-Reply-To: <alpine.DEB.1.00.0803220348520.17137@sheep.housecafe.de>
Message-ID: <alpine.DEB.1.10.0803270918450.5041@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <200803150108.04008.chunkeey@web.de> <200803151432.11125.chunkeey@web.de> <200803152234.53199.chunkeey@web.de> <alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de>
 <20080317173609.GD29322@agk.fab.redhat.com> <alpine.DEB.1.00.0803220348520.17137@sheep.housecafe.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Christian Kujau wrote:
> On Mon, 17 Mar 2008, Alasdair G Kergon wrote:
>> From: Milan Broz <mbroz@redhat.com>
>> 
>> Fix regression in dm-crypt introduced in commit
>> 3a7f6c990ad04e6f576a159876c602d14d6f7fef
>> (dm crypt: use async crypto).

I noticed that this patch[0] hasn't made it into mainline yet,
will this be included or is this fixed by something else?

Thanks,
Christian.

[0] http://lkml.org/lkml/2008/3/17/214
-- 
BOFH excuse #416:

We're out of slots on the server
