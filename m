Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbZG2Ooh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbZG2Ooh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZG2Oog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:44:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56827 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbZG2Oof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:44:35 -0400
Message-ID: <4A706168.2090804@redhat.com>
Date: Wed, 29 Jul 2009 17:49:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] kvm/svm: handle #pf intercepts in nested_svm_exit_handled
 directly
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-12-git-send-email-joerg.roedel@amd.com> <4A705AB4.90103@suse.de> <4A706035.9020502@redhat.com> <4A705F7F.3030507@suse.de>
In-Reply-To: <4A705F7F.3030507@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2009 05:41 PM, Alexander Graf wrote:
>> Me too.  Why ack then?
>>      
>
> Because the patch is fine. It's just the description that's missing.
> Shouldn't I ack when the only thing I don't like is the description?
>    

The description is part of the patch, an important one.

-- 
error compiling committee.c: too many arguments to function

