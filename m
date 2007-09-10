Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbXIJRNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbXIJRNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758954AbXIJRNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:13:04 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43724 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759121AbXIJRNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:13:02 -0400
Date: Mon, 10 Sep 2007 22:53:34 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, dhaval@linux.vnet.ibm.com
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
Message-ID: <20070910172334.GB19100@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070910171049.GA16048@linux.vnet.ibm.com> <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 07:05:00PM +0200, Jan Engelhardt wrote:
> On Sep 10 2007 22:40, Srivatsa Vaddagiri wrote:
> >+#ifdef CONFIG_FAIR_GROUP_SCHED
> >+SUBSYS(cpuctlr)
> >+#endif
> 
> cpuctl, cpuctrl, cpu_controller?

*shrug* .. I used "cpuctlr" to mean "CPU Controller". Any other short names
would do. From your list, cpuctl or cpuctrl both qualifies IMO!

Unless folks have strong objection to it, I prefer "cptctlr", the way it is.

-- 
Regards,
vatsa
