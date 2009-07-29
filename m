Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbZG2Nnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbZG2Nnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204AbZG2Nnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:43:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44971 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbZG2Nnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:43:42 -0400
Message-ID: <4A705327.8050101@redhat.com>
Date: Wed, 29 Jul 2009 16:48:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12] Nested SVM cleanups
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <4A70492E.2080705@redhat.com> <20090729130944.GE18313@amd.com> <4A704F5B.9000800@redhat.com> <20090729133840.GG18313@amd.com>
In-Reply-To: <20090729133840.GG18313@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2009 04:38 PM, Joerg Roedel wrote:
>> In that case, the next interesting target is nested npt.  This may
>> actually make nsvm perform well.  Any plans?
>>      
>
> Yes. Plan is to implement this when I am through with the cleanups.
>    

Great, this promises to be the most interesting area of development in 
kvm for those of us who don't read ppc.

-- 
error compiling committee.c: too many arguments to function

