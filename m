Return-Path: <linux-kernel-owner+w=401wt.eu-S932835AbZJLQmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbZJLQmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932369AbZJLQmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:42:00 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:44633 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbZJLQl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=c8KntnpOEC5WzsN2naBVFZrfEVm4nMd9+HRmCJvnEg5r8Lkz9BY454kcdp6hTdag9v
         kB/7xaRn8g82cvsiOFhqKIH6twt1G50aRnamu9hLZWkbQGsD7rUP8XRYa/ixuaQuhU1T
         b0fovYkGEQDhTnkoD+h3X2OCnJXWgYHRpoRpc=
MIME-Version: 1.0
In-Reply-To: <20091012163640.GC20786@sortiz.org>
References: <1255197244-20121-1-git-send-email-vapier@gentoo.org> 
	<20091012163640.GC20786@sortiz.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 12 Oct 2009 12:41:03 -0400
Message-ID: <8bd0f97a0910120941t32e5ece2qc448acc94eb043e2@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 1/5] mfd: ADP5520 Multifunction LCD 
	Backlight and Keypad Input Device Driver
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 12:36, Samuel Ortiz wrote:
> On Sat, Oct 10, 2009 at 01:54:00PM -0400, Mike Frysinger wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> Base driver for Analog Devices ADP5520/ADP5501 MFD PMICs
>
> MFD and GPIO, backlight and input drivers applied, thanks.

awesome

> About the LED one, I would really appreciate if you could have the LED
> maintainer review it or/and ack it.

you and me both ;)
-mike
