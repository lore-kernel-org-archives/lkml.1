Return-Path: <linux-kernel-owner+w=401wt.eu-S967362AbXG3Rx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967362AbXG3Rx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965929AbXG3RxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:53:17 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:46546
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965837AbXG3RxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:53:16 -0400
Date: Mon, 30 Jul 2007 10:51:42 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andre Noll <maan@systemlinux.org>,
       Wim Van Sebroeck <wim@iguana.be>, Borislav Petkov <bbpetkov@yahoo.de>,
       Bret Towe <magnade@gmail.com>, Nick Piggin <npiggin@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jakub Jelinek <jakub@redhat.com>,
       Eric Sesterhenn <snakebyte@gmx.de>, Andi Kleen <ak@suse.de>,
       Sid Boyce <g3vbv@blueyonder.co.uk>
Subject: Re: [1/3] 2.6.23-rc1: known regressions v3
In-Reply-To: <6bffcb0e0707301048k6aaa9e40ve9f319f3d999713b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707301050330.12232@asgard.lang.hm>
References: <46AE12EE.1070501@googlemail.com>  <Pine.LNX.4.64.0707300942460.11330@asgard.lang.hm>
 <6bffcb0e0707301048k6aaa9e40ve9f319f3d999713b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007, Michal Piotrowski wrote:

> On 30/07/07, david@lang.hm <david@lang.hm> wrote:
>> On Mon, 30 Jul 2007, Michal Piotrowski wrote:
>>
>>> Subject         : /usr/bin/ld: section .text [ffffffffff700500 -> ffffffffff7007e3] overlaps section .gnu.version_d [ffffffffff7004d8 -> ffffffffff70050f]
>>> References      : http://lkml.org/lkml/2007/7/22/239
>>> Last known good : ?
>>> Submitter       : Andre Noll <maan@systemlinux.org>
>>> Caused-By       : ?
>>> Handled-By      : Andi Kleen <ak@suse.de>
>>>                  Jakub Jelinek <jakub@redhat.com>
>>> Status          : problem is being debugged
>>
>> I'm seeing this on 2.6.22.1 as well.
>
> Ok, so it is not a regression.

not from 2.6.22.1, it may still be a problem worth tracking. I don't 
remember seeing it prior to 2.6.22.1

David Lang

>> the resulting kernel has seemed to
>> work for me so I was ignoreing it.
>>
>> David Lang
>>
>
> Regards,
> Michal
>
>
