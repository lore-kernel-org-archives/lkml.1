Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbXJIUGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbXJIUGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 16:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXJIUGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 16:06:43 -0400
Received: from ns.suse.de ([195.135.220.2]:49375 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbXJIUGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 16:06:43 -0400
To: "Mark Langsdorf" <mark.langsdorf@amd.com>
Cc: cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] architectural pstate driver for powernow-k8
References: <200710091446.38432.mark.langsdorf@amd.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Oct 2007 22:06:39 +0200
In-Reply-To: <200710091446.38432.mark.langsdorf@amd.com>
Message-ID: <p73fy0k3ve8.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Mark Langsdorf" <mark.langsdorf@amd.com> writes:

> This patch should apply cleanly to the 2.6.22.6 kernel.

Isn't that a little old? The earliest this could be merged
is the upcomming 2.6.24 tree. Best you submit it against .23
or better -mm.

> This architectural driver should work on all future AMD processors.

That's great. Requiring new powernow drivers all the time was
a little annoying in the past.

-Andi
