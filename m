Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbXIJRSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbXIJRSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758954AbXIJRSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:18:00 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60154 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbXIJRR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:17:59 -0400
Date: Mon, 10 Sep 2007 22:58:36 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, dhaval@linux.vnet.ibm.com
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
Message-ID: <20070910172836.GB16048@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070910171049.GA16048@linux.vnet.ibm.com> <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr> <20070910172334.GB19100@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910172334.GB19100@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 10:53:34PM +0530, Srivatsa Vaddagiri wrote:
> > cpuctl, cpuctrl, cpu_controller?
> 
> *shrug* .. I used "cpuctlr" to mean "CPU Controller". Any other short names
> would do. From your list, cpuctl or cpuctrl both qualifies IMO!
> 
> Unless folks have strong objection to it, I prefer "cptctlr", the way it is.

s/cptctlr/cpuctlr !

-- 
Regards,
vatsa
