Return-Path: <linux-kernel-owner+w=401wt.eu-S1763936AbXLMQsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763936AbXLMQsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763798AbXLMQsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:48:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50436 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763877AbXLMQsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:48:12 -0500
Date: Thu, 13 Dec 2007 17:47:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 0/19 -v4] desc_struct integration
Message-ID: <20071213164701.GB4865@elte.hu>
References: <11975113122984-git-send-email-gcosta@redhat.com> <1197554287294-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197554287294-git-send-email-gcosta@redhat.com>
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


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

> Since the last version of it received no comments on the interfaces, 
> here it goes a version, that I feel ready for inclusion.
> 
> The comments regarding style, specially the elimination of the 
> #defines in the desc_struct definition were merged. I also implemented 
> the vmi functions, missing last time.
> 
> Ingo, in the absense of further complaints, could you please push to 
> the x86 tree?

well i've already included v3 in x86.git (and it's pushed out), and that 
was looking good already in review and in testing - could you send a 
v3->v4 delta too?

	Ingo
