Return-Path: <linux-kernel-owner+w=401wt.eu-S934044AbXINQMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbXINQMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760125AbXINQMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:12:09 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50343 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbXINQMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:12:07 -0400
Date: Fri, 14 Sep 2007 21:52:24 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, Jan Engelhardt <jengelh@computergmbh.de>,
       dhaval@linux.vnet.ibm.com, menage@google.com
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
Message-ID: <20070914162224.GA29072@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070910102259.dc45a481.akpm@linux-foundation.org> <20070910174649.GA16222@linux.vnet.ibm.com> <b647ffbd0709101528i7440a0f9m9837065a43e4a720@mail.gmail.com> <20070911044145.GC16222@linux.vnet.ibm.com> <b647ffbd0709110253y7d9564c4j88aa134330e2a292@mail.gmail.com> <20070912114202.GA30385@linux.vnet.ibm.com> <b647ffbd0709120925i690ecb11i975149037fc72979@mail.gmail.com> <20070913123324.GA6214@linux.vnet.ibm.com> <20070914094158.GA1990@elte.hu> <20070914155913.GA8751@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914155913.GA8751@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 09:29:13PM +0530, Srivatsa Vaddagiri wrote:
> 2. Enable only one form of grouping, which is task-container based. Provide a 
>    user-space daemon (attached) which can automatically put tasks of different 
Oops ..forgot to attach. But I realize that I had already sent the
source for the daemon here:

	http://article.gmane.org/gmane.linux.kernel/553267

-- 
Regards,
vatsa
