Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938AbZEUHse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbZEUHse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 03:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZEUHs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 03:48:27 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:17501 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751455AbZEUHs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 03:48:27 -0400
Message-ID: <4A150747.3070304@panasas.com>
Date: Thu, 21 May 2009 10:48:23 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>
Subject: Re: linux-next: kvm tree build failure
References: <20090521172122.bb12027c.sfr@canb.auug.org.au> <4A15038B.1090204@redhat.com> <4A15049F.8000707@panasas.com> <4A150515.8030608@redhat.com>
In-Reply-To: <4A150515.8030608@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2009 07:48:27.0165 (UTC) FILETIME=[86A944D0:01C9D9E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2009 10:39 AM, Avi Kivity wrote:
> Boaz Harrosh wrote:
>>> I'll look for a ppc machine for build testing.
>>>
>>>     
>> Can't you cross compile for ppc? I can't remember someone posted a link
>> with binary cross-compiler packages a while back.
>>
>>   
> 
> I have userspace to test as well, which needs a ton of cross-compiled 
> libraries.
> 

A cross compiler produces native foreign code. A Native distribution with
binary libraries will work just as well.

Do you mean to set up all the build environment and dependencies?
Perhaps get a ready made ppc linux image, mount and chroot into it
and build that way.

If only you had an emulator for ppc?

Boaz
