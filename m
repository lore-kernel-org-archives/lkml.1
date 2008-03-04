Return-Path: <linux-kernel-owner+w=401wt.eu-S1763465AbYCDBiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465AbYCDBiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 20:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbYCDBh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 20:37:56 -0500
Received: from ozlabs.org ([203.10.76.45]:41111 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651AbYCDBh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 20:37:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH] lguest: Accept guest _PAGE_PWT page table entries
Date: Tue, 4 Mar 2008 12:37:09 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org
References: <20080206232134.GB6450@ubuntu> <20080206235923.GA19843@elte.hu> <20080207005120.GA5751@ubuntu>
In-Reply-To: <20080207005120.GA5751@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041237.10195.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2008 11:51:20 Ahmed S. Darwish wrote:
> On Thu, Feb 07, 2008 at 12:59:23AM +0100, Ingo Molnar wrote:
> > yes, should be safe. Could you send a patch so that others can apply it
> > too?
>
> Ofcourse :) :
>
> Accept guest _PAGE_PWT page table entries, otherwise lguest will
> always fail with a "bad page table entry" message.
>
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Thanks for tracking this Ahmed, and thanks to Ingo for pushing it upstream.

Cheers,
Rusty.
