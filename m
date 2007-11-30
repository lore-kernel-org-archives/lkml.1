Return-Path: <linux-kernel-owner+w=401wt.eu-S934669AbXK3D6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934669AbXK3D6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 22:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762406AbXK3D6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 22:58:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43481 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbXK3D6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 22:58:33 -0500
Message-ID: <474F8984.4010602@zytor.com>
Date: Thu, 29 Nov 2007 19:54:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Chris Snook <csnook@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>	<474F6E7A.3090705@redhat.com>	<474F7DC4.8000607@zytor.com> <20071129194027.10046988@laptopd505.fenrus.org>
In-Reply-To: <20071129194027.10046988@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>
>> Anyway, I don't think compiling bc is hard on anything which has a C 
>> compiler.
> 
> alternative is to just also ship the precomputed values ;-)
> 

Oh, come on... it's not like bc is some obscure thing.  It's a POSIX 
utility.

	-hpa
