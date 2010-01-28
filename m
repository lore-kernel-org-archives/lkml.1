Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449Ab0A1VIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab0A1VIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 16:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436Ab0A1VIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 16:08:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:59115 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab0A1VIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 16:08:16 -0500
Message-ID: <4B61FC58.1030101@kernel.org>
Date: Thu, 28 Jan 2010 13:06:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v2] x86/pci: print ioh resources only
References: <201001261902.13911.rjw@sisk.pl> <20100126101752.78196900@jbarnes-piketon> <4B5F735B.2040308@kernel.org> <alpine.LFD.2.00.1001271748300.3570@localhost.localdomain> <20100127192409.79af96db@jbarnes-piketon> <20100128040226.GB8964@jgarrett.org> <20100128082432.05a97ebc@jbarnes-piketon> <4B61D7C4.1050405@kernel.org> <alpine.LFD.2.00.1001281052510.22433@localhost.localdomain> <4B61E116.6050208@kernel.org> <20100128193027.GA13741@dspnet.fr.eu.org>
In-Reply-To: <20100128193027.GA13741@dspnet.fr.eu.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2010 11:30 AM, Olivier Galibert wrote:
> On Thu, Jan 28, 2010 at 11:10:14AM -0800, Yinghai Lu wrote:
>>
>> don't use them for peer pci root bus resource yet.
>> so could cross check _CRS results
>>
>> -v2: dont put info struct in stack according to Linus.
>>      because that is kbytes big
> 
> No kfree?

thanks.

anyway Jesse don't need print out.

YH
