Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYBIJbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYBIJbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 04:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYBIJbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 04:31:15 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:3133 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYBIJbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 04:31:13 -0500
Message-ID: <47AD72DC.9070803@free-electrons.com>
Date: Sat, 09 Feb 2008 10:31:08 +0100
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some	processors
References: <200802082347.25364.michael-lists@free-electrons.com> <20080208231130.GA10511@elte.hu>
In-Reply-To: <20080208231130.GA10511@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2008 12:11 AM, Ingo Molnar wrote:
>
> would be nice to hide these #ifdefs into include files. (define 
> early_init_intel()/etc. as an empty inline in an include file)
>   
Hi Ingo,

Thank you very much for your quick review and your suggestions. I will
try to post the corresponding update tonight.

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

