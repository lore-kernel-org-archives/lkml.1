Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbXLEQst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbXLEQst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXLEQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:48:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40327 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbXLEQsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:48:40 -0500
Date: Wed, 5 Dec 2007 17:48:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] UML - change sigcontext fields to match x86
Message-ID: <20071205164816.GB25641@elte.hu>
References: <20071205163024.GA7241@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205163024.GA7241@c2.user-mode-linux.org>
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


* Jeff Dike <jdike@addtoit.com> wrote:

> git-x86, in commit 70aa1bd3839e3ec74ce65316528a82570e8de666, changed a 
> lot of the sigcontext field names.  This patch changes UML usage to 
> match.

thanks, we indeed missed those. Should we carry this in x86.git, or 
would you like to carry this in your UML tree?

	Ingo
