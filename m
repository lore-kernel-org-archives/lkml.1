Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbZLaSl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbZLaSl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 13:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZLaSl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 13:41:28 -0500
Received: from 62.1.125.199.dsl.dyn.forthnet.gr ([62.1.125.199]:19735 "EHLO
	poseidon.vergina.dyndns.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019AbZLaSl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 13:41:26 -0500
Message-ID: <4B3CF04E.8070603@asyr.hopto.org>
Date: Thu, 31 Dec 2009 20:41:18 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091229 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: gentoo-user@lists.gentoo.org, Dirk Heinrichs <dirk.heinrichs@online.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [gentoo-user] RAM installed vs reported
References: <4B3B3043.20400@asyr.hopto.org>	<200912301208.54359.dirk.heinrichs@online.de>	<4B3B38F2.6090006@asyr.hopto.org> <m3fx6r8a0l.fsf@intrepid.localdomain>
In-Reply-To: <m3fx6r8a0l.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 12/31/2009 04:59 PM Krzysztof Halasa wrote the following:
> Thanasis <thanasis@asyr.hopto.org> writes:
>
>> I thought CONFIG_HIGHMEM4G had to do with more than 4GB of RAM.
>> Now I can see that the associated help says it is for an amount between
>> 1 and 4GB.
>
> Depends on the "split" used. With 2 GB : 2 GB you can have all-lowmem
> 1.5 GB RAM, without CONFIG_HIGHMEM*. 2 GB of per-process address space
> is usually not a problem.
How do you implement that? What do you mean 2GB:2GB split ?
