Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbZFDMDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZFDMDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZFDMDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:03:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37411 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbZFDMDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:03:03 -0400
Message-ID: <4A27B7D2.50503@redhat.com>
Date: Thu, 04 Jun 2009 15:02:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [KVM-RFC PATCH 0/2] irqfd: use POLLHUP notification for close()
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602160434.GA6827@redhat.com> <4A254FD7.5090302@novell.com> <20090602162021.GB6827@redhat.com> <4A255484.6060401@novell.com> <20090602165949.GD6827@redhat.com> <4A256431.2080101@novell.com> <20090603063956.GA8134@redhat.com> <4A27A10C.2050405@redhat.com> <4A27B37F.1060307@gmail.com> <4A27B4F0.9060603@redhat.com> <4A27B597.7090003@gmail.com>
In-Reply-To: <4A27B597.7090003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Since Paul ok'd (I think?) the srcu design, and the only other feedback
> was the key-bitmap thing from Davide, I will go ahead and push a v2 with
> just that one fix (unless there is any other feedback?)
>   

I'll do a detailed review on your next posting.  When I see a long 
thread I go hide under the bed, where there is no Internet access.

-- 
error compiling committee.c: too many arguments to function

