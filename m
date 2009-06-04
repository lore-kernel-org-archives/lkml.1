Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZFDLuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZFDLuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZFDLun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:50:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33158 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbZFDLum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:50:42 -0400
Message-ID: <4A27B4F0.9060603@redhat.com>
Date: Thu, 04 Jun 2009 14:50:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [KVM-RFC PATCH 0/2] irqfd: use POLLHUP notification for close()
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602160434.GA6827@redhat.com> <4A254FD7.5090302@novell.com> <20090602162021.GB6827@redhat.com> <4A255484.6060401@novell.com> <20090602165949.GD6827@redhat.com> <4A256431.2080101@novell.com> <20090603063956.GA8134@redhat.com> <4A27A10C.2050405@redhat.com> <4A27B37F.1060307@gmail.com>
In-Reply-To: <4A27B37F.1060307@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>> I agree that deassign is needed for reasons of symmetry, and that it
>> can be added later.
>>
>>     
> Cool.
>
> FYI: Davide's patch has been accepted into -mm (Andrew CC'd).  I am not
> sure of the protocol here, but I assume this means you can now safely
> pull it from -mm into kvm.git so the prerequisite for 2/2 is properly met.
>   

I'm not sure either.

But I think I saw a "Thanks for catching that" for 2/2?

-- 
error compiling committee.c: too many arguments to function

