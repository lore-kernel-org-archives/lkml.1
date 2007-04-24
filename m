Return-Path: <linux-kernel-owner+w=401wt.eu-S1423116AbXDXV0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423116AbXDXV0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423117AbXDXV0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:26:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423116AbXDXV0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:26:01 -0400
Message-ID: <462E75E6.5030800@redhat.com>
Date: Tue, 24 Apr 2007 17:25:58 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: William Heimbigner <icxcnika@mar.tar.cc>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] cpufreq: allow full selection of default governors
References: <Pine.LNX.4.64.0704242057430.25153@server.thyself> <20070424211253.GG23598@redhat.com>
In-Reply-To: <20070424211253.GG23598@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Tue, Apr 24, 2007 at 09:03:23PM +0000, William Heimbigner wrote:
>  > The following patches should allow selection of conservative, powersave, and 
>  > ondemand in the kernel configuration.
> 
> This has been rejected several times already.
> Ondemand and conservative isn't a viable governor for all cpufreq implementations
> (ie, ones with high switching latencies).  Also, see the comment in the Kconfig
> a few lines above where you are adding this.

It would be nice to have powersave available as the default.
