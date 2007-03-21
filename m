Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbXCUXhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbXCUXhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbXCUXhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:37:14 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59052 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbXCUXhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:37:12 -0400
Date: Wed, 21 Mar 2007 16:36:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux list <linux-kernel@vger.kernel.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: rsdl improvements
Message-Id: <20070321163658.535cbd7e.akpm@linux-foundation.org>
In-Reply-To: <200703220429.45311.kernel@kolivas.org>
References: <200703220429.45311.kernel@kolivas.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 04:29:44 +1100
Con Kolivas <kernel@kolivas.org> wrote:

> Further improve the deterministic nature of the RSDL cpu scheduler and make
> the rr_interval tunable.

I might actually need to drop RSDL from next -mm, see if those sched oopses
whcih several people have reported go away.
