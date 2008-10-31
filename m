Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbYJaPyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbYJaPyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYJaPya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:54:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45408 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbYJaPya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:54:30 -0400
Message-ID: <490B2A10.2030801@zytor.com>
Date: Fri, 31 Oct 2008 08:53:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: cpu2000(both float and int) 13% regression with 2.6.28-rc1
References: <1225175522.1685.57.camel@ymzhang> <20081028080327.GB15734@elte.hu> <20081028202649.GJ30573@linux-os.sc.intel.com> <7E82351C108FA840AB1866AC776AEC46401F518D@orsmsx505.amr.corp.intel.com> <490A5A80.3070203@zytor.com> <20081031100201.GA17426@elte.hu>
In-Reply-To: <20081031100201.GA17426@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> OK, thought it already had been.  I will investigate later tonight.
> 
> i've picked it up into x86/urgent - see the commit below.
> 

Thank you.  Sorry for not really having been there this week.

	-hpa
