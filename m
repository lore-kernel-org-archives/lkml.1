Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYAJJgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYAJJgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYAJJf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:35:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52733 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYAJJfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:35:55 -0500
Date: Thu, 10 Jan 2008 10:35:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: uml and -regparm=3
Message-ID: <20080110093536.GA17808@elte.hu>
References: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu> <20080110073215.GA11506@elte.hu> <E1JCtMI-0007jw-5U@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JCtMI-0007jw-5U@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> Thanks.  Patch works, but needed to add asmregparm to the definitions 
> as well, plus added default define into <linux/linkage.h> (updated 
> patch below).

thanks, applied.

	Ingo
