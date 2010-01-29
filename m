Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793Ab0A2MnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0A2MnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 07:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495Ab0A2MnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 07:43:18 -0500
Received: from gra-lx1.iram.es ([150.214.224.41]:49077 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab0A2MnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 07:43:18 -0500
X-Greylist: delayed 1045 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2010 07:43:18 EST
Date: Fri, 29 Jan 2010 13:25:36 +0100
From: Gabriel Paubert <paubert@iram.es>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCHv3 2/2] powerpc: implement arch_scale_smt_power for
	Power7
Message-ID: <20100129122536.GA11156@iram.es>
References: <1264017638.5717.121.camel@jschopp-laptop> <1264017847.5717.132.camel@jschopp-laptop> <1264548495.12239.56.camel@jschopp-laptop> <1264720855.9660.22.camel@jschopp-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264720855.9660.22.camel@jschopp-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 05:20:55PM -0600, Joel Schopp wrote:
> On Power7 processors running in SMT4 mode with 2, 3, or 4 idle threads 
> there is performance benefit to idling the higher numbered threads in
> the core.  
> 

Really 2, 3, or 4? When you have 4 idle threads out of 4, performance
becomes a minor concern, no? ;-)

	Gabriel
