Return-Path: <linux-kernel-owner+w=401wt.eu-S1760497AbYCZVuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbYCZVuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbYCZVuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:50:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393AbYCZVuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:50:23 -0400
Date: Wed, 26 Mar 2008 22:50:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Castricum <lk08@bencastricum.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH] Microcode: show results on success too plus
	fix typo
Message-ID: <20080326215013.GA32269@elte.hu>
References: <001701c88f7f$1e2b6c80$0602a8c0@links>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001701c88f7f$1e2b6c80$0602a8c0@links>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0403]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ben Castricum <lk08@bencastricum.nl> wrote:

> Show a bit more info when updating microcode. It used to be there but 
> no with DEBUG unset makes it very silent.
>
> This is my first patch, please let me know if I did anything wrong.

your patch looks good to me, but there's some whitespace damage: all 
your tabs in that patch got converted to spaces. Check out 
Documentation/email-clients.txt and please resend it so that i can apply 
it to x86.git.

	Ingo
