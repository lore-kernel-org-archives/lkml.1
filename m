Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYFPXQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYFPXQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 19:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYFPXQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 19:16:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44653 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbYFPXQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 19:16:21 -0400
Message-ID: <4856F37F.9070609@kernel.org>
Date: Mon, 16 Jun 2008 16:13:03 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make asm/asm.h work for asm code.
References: <4856E3D3.2010207@goop.org> <4856EDD3.4080808@kernel.org> <4856F261.9040504@goop.org>
In-Reply-To: <4856F261.9040504@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Jeremy Fitzhardinge wrote:
>>> This is useful for unifying some pieces of asm code.
>>>
>>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Thinking about it some more, this should be possible to do cleaner 
>> like this:
> 
> OK, how about this...

A little over the top, but looks great ;)

Acked-by: H. Peter Anvin <hpa@zytor.com>

I'll pull this into -tip once I figure out which topic it should go under.

	-hpa
