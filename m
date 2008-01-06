Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbYAFJdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbYAFJdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 04:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYAFJdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 04:33:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40287 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYAFJdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 04:33:01 -0500
Date: Sun, 6 Jan 2008 10:32:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] x86: paravirt_patch_{32|64}.c unification
Message-ID: <20080106093250.GB26291@elte.hu>
References: <200801060105.44758.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801060105.44758.mboton@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4712]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i couldnt apply your mail due to:

 User-Agent: KMail/1.9.7

and due to quoted printables:

 =20
  #else
 =20
 =2D# ifdef CONFIG_SMP

	Ingo
