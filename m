Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYLTOmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYLTOmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYLTOmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:42:24 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:61689 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYLTOmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:42:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EZXCWZNA75XOPofvQ0VjBje5Rj9lAg9+c6suYOUsX1PKazuFKXv6hVDts4hAEmalSN
         jJeUFnifhrrcPP9NQ6cqLcybQm57IhQ+8HYt8+RlXymupEYd0EYhQ+LbDXrdJqPfmTMz
         UYB9rAX99ZgpuoHCny06Ju3zu59ccSpDbjhnk=
Message-ID: <ce0170d90812200642k7a820d48see9fd0a6d6bb078f@mail.gmail.com>
Date: Sat, 20 Dec 2008 11:42:21 -0300
From: "Sergio Luis" <eeeesti@gmail.com>
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: Halted system won't halt
Cc: "Pavel Machek" <pavel@suse.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <494CE82E.90008@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494A0711.7010804@davidnewall.com> <20081219120530.GB1599@ucw.cz>
	 <494CE82E.90008@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 9:42 AM, David Newall <davidn@davidnewall.com> wrote:
> Pavel Machek wrote:
>> On Thu 2008-12-18 18:47:21, David Newall wrote:
>>
>>> "poweroff -f -p" ... strangely came back after a few seconds.
>>>
>>
>> SMP? Care to try Mark Lord's recent patch on lkml?
> A surprise to me; yes, the kernel is configured for SMP.    (The
> hardware isn't.)  I can't find the patch.  Got another hint for me?
>
> Thanks.
> --

This is the thread he was talking about, I guess:
http://lkml.org/lkml/2008/12/17/225

Sergio.
