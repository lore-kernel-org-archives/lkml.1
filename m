Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZHQSXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZHQSXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757952AbZHQSXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:23:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60446 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948AbZHQSXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:23:03 -0400
Message-ID: <4A899FEA.9020707@zytor.com>
Date: Mon, 17 Aug 2009 11:22:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark Kelly <mark@bifferos.com>, linux-kernel@vger.kernel.org,
       Florian Fainelli <florian@openwrt.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86 CPU detection for RDC
References: <58001.1250437590@bifferos.com> <20090816155507.GA2791@elte.hu> <alpine.LNX.2.00.0908160317250.19588@cent.localnet> <20090816175204.GA28553@elte.hu> <alpine.LNX.2.00.0908160404300.20653@cent.localnet> <4A899A1D.8060808@zytor.com> <20090817180825.GA5558@elte.hu>
In-Reply-To: <20090817180825.GA5558@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2009 11:08 AM, Ingo Molnar wrote:
> 
> X86_RDC321X already exists in arch/x86/Kconfig. It should probably 
> grow a 'depends on PCI' rline or so.
> 

Sounds like it.

	-hpa

