Return-Path: <linux-kernel-owner+w=401wt.eu-S1760754AbZFIM1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754AbZFIM1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759051AbZFIM12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:27:28 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:56392 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330AbZFIM12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZkDdKZ3Ij9Z7R75AIr4939Gm42us4GvJulAv8MZUgK5BqGg/s899QYcdZsUL+K6RI6
         dMWiBF6lvTvZmPGtZbg0rEd9ACtCtxanW1cJXuBE7NCfo6OO1KJ6XWnlrs52W4u7LQm4
         rTvjlwHArDzXtMAZ66deoLbPpXEXEUyQeExCY=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
In-Reply-To: <20090602133312.68158cd5.akpm@linux-foundation.org>
References: <17be05570905230453i591eb83bnb359f6365c109718@mail.gmail.com>
	 <20090526151621.a7446c60.akpm@linux-foundation.org>
	 <17be05570905301105h395689ja33afa96e7751381@mail.gmail.com>
	 <20090601165457.a1cc1025.akpm@linux-foundation.org>
	 <20090601200821.62b04e43@mycelium.queued.net>
	 <4A24965C.2020901@cosmicpenguin.net>
	 <17be05570906020114k7f2a3096h48335d509951cf90@mail.gmail.com>
	 <20090602133312.68158cd5.akpm@linux-foundation.org>
Date: Tue, 9 Jun 2009 14:27:30 +0200
X-Google-Sender-Auth: 6c248da5eba32218
Message-ID: <17be05570906090527l5861a79dq2ca8e6cf0ba084fe@mail.gmail.com>
Subject: Re: [PATCH v2 001/001] gpio: AMD CS5535/CS5536 GPIO driver
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jordan@cosmicpenguin.net, dilinger@collabora.co.uk, david-b@pacbell.net,
       gardner.ben@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> So maybe we should decide whether we take Andre's or my approach
>> and then adjust it.
>>
>
> I think I'll drop gpio-amd-cs5535-cs5536-gpio-driver.patch while you
> guys sort all this out, please.

So, how to carry on with this? Shall I adapt Andre's version to mine or
will Andre take care of this version?

A comment from Andre would be fine.
