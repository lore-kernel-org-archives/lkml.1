Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbXEARMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbXEARMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbXEARMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:12:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:26268 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbXEARMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:12:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qTT74IbLRQK4B1gUSH52er7NtNwhV3AP2X+8kIs3//Df2+YL3eVySBb+LO4dABBTAxbs7NrmQ0VROdpxBAOd3uHsnnJoYnSgqfCHOtzGzMbpE2VciYhF0KWBfjn/qx6BeQNkqxcdbVpyRUCc+xs7K2E9Gz9JE8UZEKSUs6GrCMM=
Message-ID: <84144f020705011012w53a39500of8e9a02b266a59d9@mail.gmail.com>
Date: Tue, 1 May 2007 20:12:28 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: 2.6.22 -mm merge plans
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, hch@lst.de, npiggin@suse.de, a.p.zijlstra@chello.nl
In-Reply-To: <p73y7k8ybvi.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <84144f020705010217j738e461ey6b09fd738574fb70@mail.gmail.com>
	 <p73y7k8ybvi.fsf@bingen.suse.de>
X-Google-Sender-Auth: 9b74e08c33e6882f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On 01 May 2007 14:19:45 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> Also have the cache performance concerns raised on the original review
> been addressed?

I am only aware of the fget_light() related issues Eric Dumazet raised
but it's fixed. If you're thinking of something else, could you please
remind me what it is?
