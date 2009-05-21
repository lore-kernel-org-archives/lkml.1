Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZEUKFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZEUKFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZEUKFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:05:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34360 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbZEUKFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:05:35 -0400
Message-ID: <4A152759.1050200@redhat.com>
Date: Thu, 21 May 2009 13:05:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>
Subject: Re: linux-next: kvm tree build failure
References: <20090521172122.bb12027c.sfr@canb.auug.org.au> <4A15038B.1090204@redhat.com> <4A15049F.8000707@panasas.com> <4A150515.8030608@redhat.com> <4A150747.3070304@panasas.com>
In-Reply-To: <4A150747.3070304@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
>> I have userspace to test as well, which needs a ton of cross-compiled 
>> libraries.
>>
>>     
>
> A cross compiler produces native foreign code. A Native distribution with
> binary libraries will work just as well.
>
> Do you mean to set up all the build environment and dependencies?
> Perhaps get a ready made ppc linux image, mount and chroot into it
> and build that way.
>
> If only you had an emulator for ppc?
>   

Life's too short for emulators.

-- 
error compiling committee.c: too many arguments to function

