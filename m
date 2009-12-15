Return-Path: <linux-kernel-owner+w=401wt.eu-S1751444AbZLOGev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbZLOGev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbZLOGeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:34:50 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:44168 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZLOGet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:34:49 -0500
MIME-Version: 1.0
In-Reply-To: <20091213212504.GD5114@elf.ucw.cz>
References: <20091205221100.GA32522@elf.ucw.cz>
	 <1260054737.23633.35.camel@desktop>
	 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
	 <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
	 <1260627482.20913.7.camel@desktop>
	 <d6200be20912121434x1a247837w75c518ba20fe684f@mail.gmail.com>
	 <20091213212504.GD5114@elf.ucw.cz>
Date: Mon, 14 Dec 2009 22:34:48 -0800
Message-ID: <d6200be20912142234ia050c67p34fd2672e7248170@mail.gmail.com>
Subject: Re: tree with htc dream support
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 1:25 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> > Arve's about to take our common and msm trees and rebase them over the .32,
>> >> > which may be useful for reference -- at least as a snapshot of a fully
>> >> > functional set of patches that android donut and eclair run on, on
>> >> > production hardware.  We'll make that available as soon as we have something
>> >> > that's bootable.
>> >> >
>> >> > Brian
>> >> >
>> >> >
>> >>
>> >> A first pass of this is available in the android-msm-2.6.32-test1
>> >> branch at git://android.git.kernel.org/kernel/experimental.git.
>> >>
>> >> http://android.git.kernel.org/?p=kernel/experimental.git;a=shortlog;h=refs/heads/android-msm-2.6.32-test1
>> >
>> > Does this have the the newest wakelock code in it? From the all the
>> > re-writes that you've done.
>>
>> No.
>
> One more wish list item: many drivers are now available in
> drivers/staging/dream, and are being slowly cleaned up. Would it be
> possible to start using those for android-msm-2.6.32 tree?
>
> You'll need to reapply some stuff I had to remove (like wakelocks),
> but it should be still better/less work long term to patch those back
> in than maintaining separate copy. Diff should get much smaller...
>                                                                        Pavel

I do plan to look at these, but I don't know when I'll get to it.

-- 
Arve Hjønnevåg
