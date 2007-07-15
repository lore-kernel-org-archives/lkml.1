Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbXGOQak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbXGOQak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbXGOQac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:30:32 -0400
Received: from dns.hk.18mail.cn ([210.245.210.181]:45363 "EHLO
	hkm1.server.hk.18mail.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbXGOQac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:30:32 -0400
Message-ID: <469A4B9B.4040008@zh-kernel.org>
Date: Mon, 16 Jul 2007 00:30:19 +0800
From: TripleX Chung <triplex@zh-kernel.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Ask for help, about the trivial patches.
References: <4697C980.1040902@zh-kernel.org> <9a8748490707131354y37793f0ag2c01b2bdf968f8cc@mail.gmail.com>
In-Reply-To: <9a8748490707131354y37793f0ag2c01b2bdf968f8cc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Note: my explanations below are based on how I understand these
> things, but I'm not the trivial patch monkey nor did I help create
> these guidelines, so I'm in no way authoritative on the subject.
>
> On 13/07/07, TripleX Chung <triplex@zh-kernel.org> wrote:
>> I am working on the chinese translated version of
>> Documentation/SubmittingPatches and get some problem about the "Trivial
>> patches".I can not understand what "Trivial patches" exactly means.The
>> documentation said:
>>
>
> If you are unclear of the meaning of the word "trivial", then take a
> look here for an explanation: http://www.m-w.com/dictionary/trivial
>
Thanks for your help. 
But I still have problems.
Trivial means "of little worth or importance". But some of the examples
in the rules are important, like "runtime fixes". Spell fixes must be
unimportant, but most of the runtime fixes like memory leaks or NULL
pointers must be important. I was still a little confused with them.

-TripleX
