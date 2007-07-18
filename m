Return-Path: <linux-kernel-owner+w=401wt.eu-S1761086AbXGRWLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbXGRWLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXGRWLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:11:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:57503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbXGRWLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:11:09 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Vivek Goyal" <vgoyal@in.ibm.com>
Subject: Re: [PATCH 3/3]x86_64: early_printk for early debug port support
Date: Thu, 19 Jul 2007 00:10:53 +0200
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, "Greg KH" <gregkh@suse.de>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <86802c440705202219k5aa758ffk217626424e613ec7@mail.gmail.com>
In-Reply-To: <86802c440705202219k5aa758ffk217626424e613ec7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707190010.53702.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007 07:19:18 Yinghai Lu wrote:
> add early dbgp to early_printk.
> 
> kernel command line:
> earlyprintk=dbgp
> or
> earlyprintk=dbgp1

Just checking some old patches. Was there ever an update for this one?
What were the testing results? 

-Andi

> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 


