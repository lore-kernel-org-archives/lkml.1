Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbXFWKWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbXFWKWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 06:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXFWKWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:22:10 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:64354 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbXFWKWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aLGwMI2qKdyVMfLJ3cYC/dwavT37GVQwRwaBNUvTn44/3K3XPfxwHs4onHnBZCdDpARzdI4C7/MdvUuMQLFIv4U6fWg+TT6+e7lX2i5Sh96egN8szUaJ4bS/cVDti1x8FT1MTu75OiZNJsiRys3WQeLdwK5if184f5WZtgVZVrk=
Message-ID: <5486cca80706230322k6e3c0f81u8e3d149ca04dc041@mail.gmail.com>
Date: Sat, 23 Jun 2007 12:22:08 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070622220202.GA16872@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622220202.GA16872@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2007/6/23, Ingo Molnar <mingo@elte.hu>:
>
> i'm pleased to announce release -v18 of the CFS scheduler patchset.

I'm running -v18 on 2.6.22-rc5, no problems so far. How can I change a
task to SCHED_IDLE or SCHED_BATCH priority under CFS?


Thanks,

    ~ Antonio
