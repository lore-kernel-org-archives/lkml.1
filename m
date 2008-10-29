Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYJ2QeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYJ2QeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYJ2QeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:34:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34763 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYJ2QeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:34:07 -0400
Date: Wed, 29 Oct 2008 17:34:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jike Song <albcamus@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix inline assembly constraints
Message-ID: <20081029163400.GA14866@elte.hu>
References: <1225297937-2917-1-git-send-email-albcamus@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225297937-2917-1-git-send-email-albcamus@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jike Song <albcamus@gmail.com> wrote:

> 
> --

that was an easy patch to act upon ;-)

	Ingo
