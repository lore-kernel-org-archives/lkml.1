Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbYALCiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbYALCiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 21:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYALCiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 21:38:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:44249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbYALCiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 21:38:04 -0500
Date: Sat, 12 Jan 2008 03:37:59 +0100
From: Andi Kleen <ak@suse.de>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH/RFC] synchronize_rcu(): high latency on idle system
Message-ID: <20080112023759.GG21068@bingen.suse.de>
References: <20080112012626.GI28570@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112012626.GI28570@kvack.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And yes, the 
> network stack shouldn't call synchronize_rcu() quite so much, but fixing that 
> is a little more involved.

... but the correct solution.

-Andi
