Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYBQSE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYBQSE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYBQSEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:04:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYBQSEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:04:50 -0500
Date: Sun, 17 Feb 2008 19:03:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, ak@suse.de,
       chrisw@sous-sol.org, kiran@scalemp.com, shai@scalemp.com
Subject: Re: [PATCH 0/5] Make vsmp a paravirt client
Message-ID: <20080217180349.GU6006@elte.hu>
References: <1202756982-18244-1-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202756982-18244-1-git-send-email-gcosta@redhat.com>
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


* Glauber Costa <gcosta@redhat.com> wrote:

> This series of five patches turns the vsmp architecture support in 
> x86_64 into a paravirt client. If PARAVIRT is on, the probe function 
> vsmp_init() is run unconditionally, patching the necessary irq 
> functions accordingly if running ontop of such box.

thanks Glauber, applied. I'll reply with a few minor comments to the 
patches themselves.

	Ingo
