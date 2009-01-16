Return-Path: <linux-kernel-owner+w=401wt.eu-S1760900AbZAPPxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbZAPPxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZAPPxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:53:01 -0500
Received: from www.tglx.de ([62.245.132.106]:50502 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbZAPPxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:53:00 -0500
Date: Fri, 16 Jan 2009 16:52:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Blechmann <tim@klingt.org>
cc: Andi Kleen <ak@linux.intel.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       venkatesh.pallipadi@intel.com
Subject: Re: 2.6.28-rc9: oprofile regression
In-Reply-To: <1232105393.6378.16.camel@thinkpad>
Message-ID: <alpine.LFD.2.00.0901161651590.3400@localhost.localdomain>
References: <1229869416.6911.1.camel@thinkpad>  <1229894585.6898.6.camel@thinkpad>  <49544497.9020900@linux.intel.com>  <1230894257.6072.10.camel@thinkpad>  <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain>  <1231957184.13033.70.camel@thinkpad> 
 <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain>  <1232010853.6541.4.camel@thinkpad>  <alpine.LFD.2.00.0901152135110.3400@localhost.localdomain>  <1232067181.6134.74.camel@thinkpad>  <alpine.LFD.2.00.0901160956170.3400@localhost.localdomain>
 <1232105393.6378.16.camel@thinkpad>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009, Tim Blechmann wrote:
> nothing fancy, just the ubuntu default:
> root=UUID=7b58a11b-972a-4a67-909a-b8e48cb29da5 ro quiet splash 

Hmm, ubuntu. question: which gcc version ?

Thanks,

	tglx
