Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbXCMRb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbXCMRb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 13:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbXCMRb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 13:31:29 -0400
Received: from gw.goop.org ([64.81.55.164]:41578 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbXCMRb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 13:31:28 -0400
Message-ID: <45F6DFEF.2090008@goop.org>
Date: Tue, 13 Mar 2007 10:31:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Introduce load_TLS to the "for" loop.
References: <1173767976.10618.50.camel@localhost.localdomain> <20070313135000.GA92373@muc.de>
In-Reply-To: <20070313135000.GA92373@muc.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tue, Mar 13, 2007 at 05:39:36PM +1100, Rusty Russell wrote:
>   
>> GCC (4.1 at least) unrolls it anyway, but I can't believe this code
>>     
>
> Are you sure? Normally it doesn't unroll without -funroll-loops which
> the kernel does normally not set. Especially not with -Os builds.
>   

Does it matter either way in this case?

    J
