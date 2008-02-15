Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbYBODpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbYBODpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 22:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbYBODpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 22:45:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:46256 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303AbYBODpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 22:45:11 -0500
Cc: LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhang Wei <wei.zhang@freescale.com>
Message-Id: <DC488215-D313-41E0-A98A-1C90D02A465D@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <e9c3a7c20802141014k6018f6dfvc1a97bf81acb872e@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: dma engine drivers for 2.6.25?
Date: Thu, 14 Feb 2008 21:44:59 -0600
References: <BEF96263-F31B-472E-B31F-0751F5ABFBDA@kernel.crashing.org> <e9c3a7c20802141014k6018f6dfvc1a97bf81acb872e@mail.gmail.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 14, 2008, at 12:14 PM, Dan Williams wrote:

> On Wed, Feb 13, 2008 at 8:52 PM, Kumar Gala  
> <galak@kernel.crashing.org> wrote:
>> Dan,
>>
>> What's going on with the dma engine drivers for 2.6.25?  We had a
>> Freescale dma driver from Zhang Wei queued up but seems to have been
>> lost.
>
> I pulled it into my tree and am holding it until Zhang has an
> opportunity to address the pending review comments [1].  I also did
> not feel comfortable pushing it to Linus without a PPC maintainer's
> Acked-by/Reviewed-by.
>
> I have attached the version I am carrying.

What issues are still open.  I was under the belief that Zhang had  
resolved all the issues.

- k
