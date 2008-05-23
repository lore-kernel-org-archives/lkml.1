Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYEWPGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYEWPGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbYEWPGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:06:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44510 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176AbYEWPGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:06:23 -0400
Message-ID: <4836DD2B.5080008@zytor.com>
Date: Fri, 23 May 2008 08:05:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Move the 64-bit Intel specific parts out of setup_64.c
References: <200805221944.m4MJiA9g029838@gelk.kernelslacker.org> <20080523131506.GG9245@ucw.cz>
In-Reply-To: <20080523131506.GG9245@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> I don't get it. Original Core duo is not 64 bit capable... so this
> should go into common code?

ALL of this code should be unified.  This is a step on the way.

	-hpa
