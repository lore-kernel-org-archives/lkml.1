Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbXCPIn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbXCPIn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbXCPIn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:43:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41169 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbXCPInz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:43:55 -0400
Date: Fri, 16 Mar 2007 09:42:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 00/26] Xen-paravirt_ops: Xen guest implementation for paravirt_ops interface
Message-ID: <20070316084251.GA23174@elte.hu>
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

>  * virtual block device (blockfront)
>  * virtual network device (netfront)

note, these drivers should be submitted through the proper block drivers 
and network drivers review process - not via the x86_64 tree.

	Ingo
