Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512Ab0AUIbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0AUIbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 03:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167Ab0AUIbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 03:31:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:48006 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0AUIbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 03:31:01 -0500
Subject: Re: [PATCH 2/2] powerpc: implement arch_scale_smt_power for Power7
From: Peter Zijlstra <peterz@infradead.org>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: ego@in.ibm.com, linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <4B578731.2060709@austin.ibm.com>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop>
	 <1264020517.4283.1117.camel@laptop>  <4B578731.2060709@austin.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 09:27:39 +0100
Message-ID: <1264062459.4283.1129.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 16:44 -0600, Joel Schopp wrote:
> 
> Care to take Gautham's bugfix patch (patch 1/2) now, since it just fixes 
> a bug?  You'll need it if you ever try to make the x86 broken version work.

Sure, I'll take that, thanks!

