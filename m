Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbYBDHgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbYBDHgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 02:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYBDHgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 02:36:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47444 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbYBDHgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 02:36:44 -0500
Date: Mon, 4 Feb 2008 08:36:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-mm1
Message-ID: <20080204073626.GA19118@elte.hu>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203171634.58ab668b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/
> 
> - The x86 git tree has been dropped due to runtime failure on one of my test
>   machines

ouch - rather unlucky timing. You updated to a fresh x86.git tree which 
had this bug for a window of about 103 minutes (according to gitweb). It 
is fixed in current x86.git.

	Ingo
