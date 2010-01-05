Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492Ab0AEIGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0AEIGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420Ab0AEIGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:06:35 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45463 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab0AEIGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:06:35 -0500
Date: Tue, 5 Jan 2010 13:36:13 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v5 PATCH 0/8] CFS Hard limits - v5
Message-ID: <20100105080613.GN27899@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20100105075703.GE27899@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105075703.GE27899@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 01:27:03PM +0530, Bharata B Rao wrote:
> Hi,
> 
> This is the v5 post of CFS hard limits. In this patchset, I have
> pulled out bandwidth and runtime handling code from RT into sched.c
> so that the same code can be used by CFS hard limits.
> 
> Also I have addressed the review comments given by Peter Zijlstra for v4.

And forgot to mention that this set applies on 2.6.33-rc2.

Regards,
Bharata.
