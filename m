Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab0BROzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 09:55:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab0BROzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 09:55:11 -0500
Message-ID: <4B7D54CA.40005@redhat.com>
Date: Thu, 18 Feb 2010 16:55:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] KVM: SVM: Make lazy FPU switching work with nested
 svm
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com> <1266493115-28386-10-git-send-email-joerg.roedel@amd.com> <66C13ED8-1D62-4647-9633-D032ADD5DDA9@suse.de>
In-Reply-To: <66C13ED8-1D62-4647-9633-D032ADD5DDA9@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 04:51 PM, Alexander Graf wrote:
> On 18.02.2010, at 12:38, Joerg Roedel wrote:
>
>    
>> TDB.
>>      
> TDB? That's not a patch description.
>
>    

Short for "To De Befined", I presume.

-- 
error compiling committee.c: too many arguments to function

