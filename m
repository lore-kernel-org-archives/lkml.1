Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYDXFiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYDXFiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 01:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbYDXFhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 01:37:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYDXFhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 01:37:53 -0400
Message-ID: <48101BE2.9020506@zytor.com>
Date: Wed, 23 Apr 2008 22:34:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
References: <200804181856.m3IIuKd4007403@hera.kernel.org>	 <1208917076.9212.721.camel@pmac.infradead.org>	 <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com>	 <aa79d98a0804222159l5ae49a64n101c4b299a3242ac@mail.gmail.com>	 <480F7C11.8040302@zytor.com> <20080423185859.GB7713@cvg>	 <480FBA73.2090209@zytor.com> <1208990882.9212.855.camel@pmac.infradead.org>	 <aa79d98a0804232025p45feb6e7t4058f2eeec88f127@mail.gmail.com> <1209015106.9212.898.camel@pmac.infradead.org>
In-Reply-To: <1209015106.9212.898.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Thu, 2008-04-24 at 07:25 +0400, Cyrill Gorcunov wrote:
>> Ok, lets drop these all and forget :)
> 
> We still want to shift the definition of X86_VM_MASK inside __KERNEL__,
> don't we?

Yes.

	-hpa
