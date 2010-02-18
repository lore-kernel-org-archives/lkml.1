Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0BRNTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 08:19:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41195 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0BRNTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 08:19:36 -0500
Subject: Re: [PATCHv4 2/2] powerpc: implement arch_scale_smt_power for
 Power7
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Joel Schopp <jschopp@austin.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com
In-Reply-To: <1266499023.26719.597.camel@laptop>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop>
	 <1264548495.12239.56.camel@jschopp-laptop>
	 <1264720855.9660.22.camel@jschopp-laptop>
	 <1264721088.10385.1.camel@jschopp-laptop>
	 <1265403478.6089.41.camel@jschopp-laptop>
	 <1266142340.5273.418.camel@laptop>  <25851.1266445258@neuling.org>
	 <1266499023.26719.597.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 14:19:19 +0100
Message-ID: <1266499159.26719.605.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 14:17 +0100, Peter Zijlstra wrote:
> 
> There's one fundamental assumption, and one weakness in the
> implementation.
> 
Aside from bugs and the like.. ;-)

