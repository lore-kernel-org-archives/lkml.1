Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZJLKH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZJLKH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbZJLKHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:07:55 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:53838 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbZJLKHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:07:54 -0400
Date: Mon, 12 Oct 2009 15:31:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [v8 PATCH 0/8]: cpuidle: Cleanup cpuidle/ Introduce cpuidle to
 POWER
Message-ID: <20091012100131.GA3007@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091008094828.GA20595@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091008094828.GA20595@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R B <arun@linux.vnet.ibm.com> [2009-10-08 15:18:28]:

> Hi
> 
> Please consider this for inclusion into the testing tree.
> 
> This patchset introduces cpuidle infrastructure to POWER, prototyping
> for pSeries, and also does a major refactoring of current x86 idle
> power management and a cleanup of cpuidle infrastructure.
> 
> Earlier discussions on the same can be found at:
> 
> v7 --> http://lkml.org/lkml/2009/10/6/278
> v6 --> http://lkml.org/lkml/2009/9/22/180
> v5 --> http://lkml.org/lkml/2009/9/22/26
> v4 --> http://lkml.org/lkml/2009/9/1/133
> v3 --> http://lkml.org/lkml/2009/8/27/124
> v2 --> http://lkml.org/lkml/2009/8/26/233
> v1 --> http://lkml.org/lkml/2009/8/19/150
> 
>

I looked at the changes and they are beginning to look very good. Some
minor comments about comments in the individual patches. 

-- 
	Balbir
