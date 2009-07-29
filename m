Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbZG2OlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbZG2OlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZG2OlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:41:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbZG2OlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:41:03 -0400
Message-ID: <4A705F7F.3030507@suse.de>
Date: Wed, 29 Jul 2009 16:41:03 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] kvm/svm: handle #pf intercepts in nested_svm_exit_handled
 directly
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-12-git-send-email-joerg.roedel@amd.com> <4A705AB4.90103@suse.de> <4A706035.9020502@redhat.com>
In-Reply-To: <4A706035.9020502@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 07/29/2009 05:20 PM, Alexander Graf wrote:
>> Joerg Roedel wrote:
>>   
>>> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
>>>      
>>
>> Acked-by: Alexander Graf<agraf@suse.de>
>>
>> I'm really starting to miss comments on the commits ...
>>    
>
> Me too.  Why ack then?

Because the patch is fine. It's just the description that's missing.
Shouldn't I ack when the only thing I don't like is the description?


Alex
