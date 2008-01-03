Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYACK4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYACK4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 05:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYACK41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 05:56:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34066 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385AbYACK4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 05:56:23 -0500
Date: Thu, 3 Jan 2008 11:56:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [19/20] x86: Use shorter addresses in i386 segfault
	printks
Message-ID: <20080103105614.GF29194@elte.hu>
References: <20080103149.088038000@suse.de> <20080103005015.3F5C714D40@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103005015.3F5C714D40@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0641]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> x86: Use shorter addresses in i386 segfault printks

hm, why? It's pretty well-established that we print addresses 8 char 
wide on 32-bit.

	Ingo
