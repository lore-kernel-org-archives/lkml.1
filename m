Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbYDVWLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbYDVWLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757699AbYDVWLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:11:33 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35099 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757573AbYDVWLd (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:11:33 -0400
Date: Wed, 23 Apr 2008 08:11:08 +1000
From: David Chinner <dgc@sgi.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: remove unused parameter of xfs_qm_dqpurge
Message-ID: <20080422221108.GD103491721@sgi.com>
References: <20080419142329.GA5339@elte.hu> <200804220503.16888.vda.linux@googlemail.com> <200804220514.45191.vda.linux@googlemail.com> <200804221142.00914.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804221142.00914.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 11:42:00AM +0200, Denys Vlasenko wrote:
> Hi David,
> 
> xfs_qm_dqpurge() does not use flags parameter.
> This patch removes it.

Ok. Will test.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
