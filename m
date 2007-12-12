Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbXLLRIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbXLLRIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758245AbXLLRIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:08:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56784 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948AbXLLRIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:08:34 -0500
Date: Wed, 12 Dec 2007 18:07:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 0/6] paravirt patches - the non-integration part
Message-ID: <20071212170733.GA8345@elte.hu>
References: <11974642471600-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11974642471600-git-send-email-gcosta@redhat.com>
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

> Hi,
> 
> This series corresponds do older patches in the paravirt series that 
> was neither already applied, nor I will touch again. In general, they 
> do not touch code that can be unified (at least, without being the 
> unification a big problem on its own).
> 
> They passed through this list a lot of times, so I feel them ready for 
> inclusion, unless someone opposes.
> 
> As with the other patches, they apply to the top of linux-2.6-x86:mm

thanks, i've picked them up into x86.git, they look certainly very 
clean.

	Ingo
