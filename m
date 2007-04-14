Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbXDNArX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbXDNArX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 20:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbXDNArX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 20:47:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:47203 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbXDNArX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 20:47:23 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [patch 2.6.21-rc6] failsafe mechanism to HPET clock calibration
Date: Sat, 14 Apr 2007 02:46:47 +0200
User-Agent: KMail/1.9.6
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
       john stultz <johnstul@us.ibm.com>, shai@scalex86.org,
       benzi@scalex86.org, discuss@x86-64.org
References: <20070413232820.GA9496@localhost.localdomain>
In-Reply-To: <20070413232820.GA9496@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704140246.47937.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 April 2007 01:28:20 Ravikiran G Thirumalai wrote:
> Provide a failsafe mechanism to avoid kernel spinning for ever at read_hpet_tsc
> during early kernel bootup.
> 
> This failsafe mechanism was introduced in 21-rc,
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2f7a2a79c3ebb44f8b1b7d9b4fd3a650eb69e544
> 
> But looks like the hpet split from time.c lost the commit.
> 
> This patch reintroduces the failsafe mechanism

Added thanks

-Andi
