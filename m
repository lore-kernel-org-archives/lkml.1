Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbYCKUcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbYCKUcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYCKUcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:32:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbYCKUcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:32:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/6] signals: send_signal: factor out SIGNAL_GROUP_EXIT checks
In-Reply-To: Oleg Nesterov's message of  Tuesday, 11 March 2008 20:51:22 +0300 <20080311175122.GA586@tv-sign.ru>
References: <20080309185926.GA5649@tv-sign.ru>
	<20080311021633.BF1B326F991@magilla.localdomain>
	<20080311175122.GA586@tv-sign.ru>
X-Zippy-Says: UH-OH!!  I think KEN is OVER-DUE on his R.V. PAYMENTS and HE'S
    having a NERVOUS BREAKDOWN too!!  Ha ha.
Message-Id: <20080311203206.2DAC526F991@magilla.localdomain>
Date: Tue, 11 Mar 2008 13:32:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are arguments to be had about deciding that change to the behavior.
We can discuss it more if you like.  But that is rather different from
quietly rolling in your choices of behavior change to a "cleanup" patch.


Thanks,
Roland
