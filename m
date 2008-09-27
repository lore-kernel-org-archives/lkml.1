Return-Path: <linux-kernel-owner+w=401wt.eu-S1752480AbYI0EZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbYI0EZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 00:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbYI0EY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 00:24:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYI0EY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 00:24:57 -0400
Message-ID: <48DDB47E.8050505@zytor.com>
Date: Fri, 26 Sep 2008 21:20:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>,
       Tim Deegan <Tim.Deegan@citrix.com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>  <48DD860C.50809@goop.org> <1222485079.23825.13.camel@alok-dev1>
In-Reply-To: <1222485079.23825.13.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 
> Avoiding existing leaves,
> Microsoft's Hypervisor  is using levels 0x40000000 - 0x40000005.
> The first 2 are standard levels and the rest of them are Microsoft
> hypervisors specific levels. So started with 0x40000010.
> 

The first two?  And standard according to whom?

	-hpa
