Return-Path: <linux-kernel-owner+w=401wt.eu-S934943AbYEVNHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934943AbYEVNHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 09:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760010AbYEVNHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 09:07:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54616 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914AbYEVNG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 09:06:59 -0400
Date: Thu, 22 May 2008 15:06:58 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Bosko Radivojevic <bosko.radivojevic@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Inserting code from userspace to kernel space
In-Reply-To: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0805221506080.9332@fbirervta.pbzchgretzou.qr>
References: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-22 14:41, Bosko Radivojevic wrote:

>Hi!
>
>I'm looking for a way to insert code from user space to the kernel
>space, but without using kernel module. Actually, we are working on a
>system that has to allow end user to change part of code (one or two
>functions) that is executed from the kernel space.
>
>For now we have two different kernel modules, one exporting a function
>which another module uses. Process of compiling kernel module is quite
>ineligible for standard end user (along with the requirement to
>support multi platform cross compiling) compared to just cross
>compiling a simple code that doesn't use any libraries than libc.
>
>I know this sounds quite weird, but maybe there is a project that can help us ;)

I'm impressed you have yet refrained from coming up with the
idea of embedding Perl into the kernel.
