Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYITPE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYITPE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 11:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYITPEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 11:04:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:55941 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYITPEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 11:04:49 -0400
Message-ID: <f488382f0809200804x34d5b8b8q33d73488fa1d56d1@mail.gmail.com>
Date: Sat, 20 Sep 2008 08:04:47 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip FIXED] ftrace: add nop tracer
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080920113151.GA30234@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221818803-9616-1-git-send-email-steven@uplinklabs.net>
	 <20080919142326.29834d11.akpm@linux-foundation.org>
	 <f488382f0809191635o45f3ed17vc23380eab41b2878@mail.gmail.com>
	 <20080920061659.GF25713@elte.hu>
	 <f488382f0809200033x10d43767j95e5958a2715d14c@mail.gmail.com>
	 <20080920113151.GA30234@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 4:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Steven Noonan <steven@uplinklabs.net> wrote:
>
>> > yeah. Feel free to send a separate patch that implements Andrew's
>> > clean-up suggestion. I agree that pro>con.
>>
>> How about this patch gets applied to -tip and I submit one that drops
>> the ifdefs on this and the other tracers?
>
> yeah - it's been part of tip/master since yesterday.
>

I saw it was applied about a minute after sending that. I should've
checked first. ;)
