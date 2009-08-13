Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZHMNqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZHMNqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 09:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZHMNqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 09:46:51 -0400
Received: from mga06.intel.com ([134.134.136.21]:10793 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754553AbZHMNqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 09:46:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,374,1246863600"; 
   d="scan'208";a="438672265"
Message-ID: <4A84194A.5050206@linux.intel.com>
Date: Thu, 13 Aug 2009 06:46:50 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: state of the fastboot activities?
References: <20090813064543.GC13320@pengutronix.de>
In-Reply-To: <20090813064543.GC13320@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schwebel wrote:
> Hi Arjan,
> 
> Can you elaborate on the current state of the fastboot activities? This
> tree here:
> 
> http://git.kernel.org/?p=linux/kernel/git/arjan/linux-2.6-async-for-30.git;a=summary
> 
> came to a stop in march, and the mainline contains the asyncronous init
> stuff, but no "fastboot" parameter as described on LWN:
> 
> http://lwn.net/Articles/314808/
> 

there is no more option; the behavior is there by default.... so it's all integrated and done..
