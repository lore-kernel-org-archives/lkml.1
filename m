Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbXCPJWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbXCPJWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbXCPJWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:22:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57057 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569AbXCPJWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:22:00 -0400
Date: Fri, 16 Mar 2007 10:21:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/26] Xen-paravirt_ops: Xen guest implementation for paravirt_ops interface
Message-ID: <20070316092137.GL23174@elte.hu>
References: <20070301232443.195603797@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301232443.195603797@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> This patch series implements the Linux Xen guest as a paravirt_ops 
> backend. [...]

19/26 seems to be missing (lkml size limit?) so i couldnt review it.

	Ingo
