Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYLJJN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYLJJN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 04:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYLJJNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 04:13:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59550 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbYLJJNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 04:13:42 -0500
Message-ID: <493F87ED.3050200@redhat.com>
Date: Wed, 10 Dec 2008 11:12:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] module_refcounting and anonymous inodes
References: <200812021114.59050.borntraeger@de.ibm.com> <493E452E.4020304@redhat.com> <493E7122.5010904@redhat.com> <200812101005.10492.sheng@linux.intel.com>
In-Reply-To: <200812101005.10492.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sheng Yang wrote:
>> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
>>     
>
> But should it be 2,6,29?...
>
>   

Thanks, fixed.

-- 
error compiling committee.c: too many arguments to function

