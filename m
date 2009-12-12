Return-Path: <linux-kernel-owner+w=401wt.eu-S933459AbZLMB3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbZLMB3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933446AbZLMB3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:29:51 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:46182 "HELO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933429AbZLMB3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:29:50 -0500
MIME-Version: 1.0
In-Reply-To: <1260627482.20913.7.camel@desktop>
References: <20091205221100.GA32522@elf.ucw.cz>
	 <1260054737.23633.35.camel@desktop>
	 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
	 <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
	 <1260627482.20913.7.camel@desktop>
Date: Sat, 12 Dec 2009 14:34:45 -0800
Message-ID: <d6200be20912121434x1a247837w75c518ba20fe684f@mail.gmail.com>
Subject: Re: tree with htc dream support
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/12 Daniel Walker <dwalker@codeaurora.org>:
> On Fri, 2009-12-11 at 21:42 -0800, Arve Hjønnevåg wrote:
>> On Sat, Dec 5, 2009 at 4:38 PM, Brian Swetland <swetland@google.com> wrote:
>> > Arve's about to take our common and msm trees and rebase them over the .32,
>> > which may be useful for reference -- at least as a snapshot of a fully
>> > functional set of patches that android donut and eclair run on, on
>> > production hardware.  We'll make that available as soon as we have something
>> > that's bootable.
>> >
>> > Brian
>> >
>> >
>>
>> A first pass of this is available in the android-msm-2.6.32-test1
>> branch at git://android.git.kernel.org/kernel/experimental.git.
>>
>> http://android.git.kernel.org/?p=kernel/experimental.git;a=shortlog;h=refs/heads/android-msm-2.6.32-test1
>
>
> Does this have the the newest wakelock code in it? From the all the
> re-writes that you've done.

No.

-- 
Arve Hjønnevåg
