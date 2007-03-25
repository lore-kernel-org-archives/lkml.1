Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbXCYHcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbXCYHcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 03:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbXCYHcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 03:32:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41555 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbXCYHcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 03:32:22 -0400
Date: Sun, 25 Mar 2007 09:31:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Early hang with 2.6.21-rc4-rt1
Message-ID: <20070325073146.GB10734@elte.hu>
References: <adad52xnccs.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adad52xnccs.fsf@cisco.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland Dreier <rdreier@cisco.com> wrote:

> I'm trying to use 2.6.21-rc4-rt1 to track down who's keeping 
> interrupts off for too long. [...]

btw., is this something you know for sure (if yes, how do you know?) - 
or is it that you would like to double-check the irqs-off times of 
v2.6.21-to-be?

	Ingo
