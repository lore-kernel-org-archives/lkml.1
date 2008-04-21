Return-Path: <linux-kernel-owner+w=401wt.eu-S1762129AbYDUQ7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762129AbYDUQ7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYDUQ7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:59:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:10613 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbYDUQ7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:59:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,690,1199692800"; 
   d="scan'208";a="319529868"
Message-ID: <480CC7A7.4070709@intel.com>
Date: Mon, 21 Apr 2008 09:58:15 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080417)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anton Titov <a.titov@host.bg>, Chris Snook <csnook@redhat.com>,
       "H. Willstrand" <h.willstrand@gmail.com>, netdev@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Bad network performance over 2Gbps
References: <1208282804.23631.27.camel@localhost> <175f5a0f0804151315x1e192fc7p7dac1e84fd154211@mail.gmail.com> <48051173.5030802@intel.com> <48051734.1000107@redhat.com> <1208426550.6049.10.camel@localhost> <48078AF6.2020003@intel.com> <20080421152821.GA18452@elte.hu>
In-Reply-To: <20080421152821.GA18452@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2008 16:59:30.0781 (UTC) FILETIME=[10F170D0:01C8A3D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Kok, Auke <auke-jan.h.kok@intel.com> wrote:
> 
>> We keep seing this exact issue pop up everywhere - especially with 
>> e1000(e) datacenter users - this code _has_ to go or be fixed. Since 
>> there is a perfectly viable solution, I strongly suggest disabling it.
> 
> strongly agreed. Thanks Auke, applied.
> 
> 	Ingo


excellent, ignore my other reply to Pavel - I didn't see this reply yet :)

Thanks Ingo


Auke

