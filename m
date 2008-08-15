Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYHOLxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYHOLxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYHOLxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:53:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35659 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbYHOLxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:53:11 -0400
Date: Fri, 15 Aug 2008 13:52:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       x86@kernel.org
Subject: Re: silence mmconfig printk.
Message-ID: <20080815115253.GB32726@elte.hu>
References: <20080814190703.GA16862@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814190703.GA16862@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Dave Jones <davej@redhat.com> wrote:

> There's so much broken mmconfig hardware/bios'es out there, that 
> classing this as an error seems a little extreme. Lower its priority 
> to KERN_INFO so that it isn't so noisy when booting with 'quiet'

applied to tip/x86/urgent - thanks Dave.

	Ingo
