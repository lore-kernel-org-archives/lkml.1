Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbZE2MRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbZE2MRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZE2MRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:17:46 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:61464 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225AbZE2MRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:17:46 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH resend5 1/4] itimers: merge ITIMER_VIRT and ITIMER_PROF
 common code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090529131920.33efd035@dhcp-lab-109.englab.brq.redhat.com>
References: <20090529131920.33efd035@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 14:17:46 +0200
Message-Id: <1243599466.23657.216.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Little note, its not a resend, so resend 5 gives the wrong impression.
Its a new version, the regular way would be to write something like:

[PATCH 0/4] itimer rework -v5
  [PATCH 1/4] ...


Where you use the 0th email to indicate what the patch series is about,
and what got changed since -v4 etc..

