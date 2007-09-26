Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbXIZQNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbXIZQNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbXIZQNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:13:07 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35423 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbXIZQNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:13:06 -0400
Subject: Re: KPROBES: Instrumenting a function's call site
From: Avishay Traeger <atraeger@cs.sunysb.edu>
To: ananth@in.ibm.com
Cc: prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070926090357.GA7651@in.ibm.com>
References: <1190758358.30061.13.camel@rockstar.fsl.cs.sunysb.edu>
	 <20070926043933.GA6460@in.ibm.com>  <20070926090357.GA7651@in.ibm.com>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 12:09:35 -0400
Message-Id: <1190822975.3940.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 14:33 +0530, Ananth N Mavinakayanahalli wrote:
> What happens when the "call" is singlestepped is that the instruction
> pointer is moved to the call target. That explains the lower latency you
> are seeing. You'll need to do something along the lines I suggested in
> the earlier mail.

Can you please explain what you mean by this more clearly?  I'm not a
kprobes expert yet.  Specifically, using kprobes the way that I did,
what will the resulting code look like?  Also, what do you mean by
"singlestepped"?

Thanks,
Avishay

