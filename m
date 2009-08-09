Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZHIJfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZHIJfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 05:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZHIJfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 05:35:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55558 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458AbZHIJf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 05:35:29 -0400
Message-ID: <4A7E99B6.2000402@redhat.com>
Date: Sun, 09 Aug 2009 12:41:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/21] Nested SVM cleanups v2
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2009 12:49 PM, Joerg Roedel wrote:
> Hi,
>
> this is the second and extended version of my patchset to clean up the code for
> SVM virtualization in KVM. The patchset was tested with KVM on KVM and showed
> no regressions. It was tested with Nested Paging and with Shadow Paging on the
> first-level guest.
> As a major change this patchset enables the nested SVM code by
> default. It is still required to start qemu with -enable-nesting,
> though.
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

