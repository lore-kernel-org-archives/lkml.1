Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbYGIWxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbYGIWxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYGIWxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:53:31 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:34011 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYGIWxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:53:31 -0400
Message-ID: <487541C0.70702@keyaccess.nl>
Date: Thu, 10 Jul 2008 00:54:56 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [patch] x86 BIOS interface for RTC on SGI UV
References: <20080709202719.GB22744@sgi.com> <4875266B.4020504@keyaccess.nl> <20080709213622.GC22744@sgi.com> <4875320D.2070306@keyaccess.nl> <20080709220944.GA18690@sgi.com>
In-Reply-To: <20080709220944.GA18690@sgi.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-07-08 00:09, Russ Anderson wrote:

> Ouch.  Thanks.

Yep, should do. Pestering you about the include guard maybe missing a 
_UV in there would be going overboard...

> Index: linux/include/asm-x86/uv/bios.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux/include/asm-x86/uv/bios.h	2008-07-09 17:01:42.000000000 -0500
> @@ -0,0 +1,68 @@
> +#ifndef _ASM_X86_BIOS_H
> +#define _ASM_X86_BIOS_H

Rene.
