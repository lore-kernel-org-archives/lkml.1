Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYFRNWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYFRNWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYFRNWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:22:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:46946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbYFRNWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:22:03 -0400
Date: Wed, 18 Jun 2008 15:22:01 +0200
From: Olaf Dabrunz <od@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stefan Assmann <sassmann@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>,
       Olaf Dabrunz <od@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: Re: [PATCH 0/5] Boot IRQ quirks and rerouting [repost]
Message-ID: <20080618132201.GH10105@suse.de>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Stefan Assmann <sassmann@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jon Masters <jonathan@jonmasters.org>,
	LKML <linux-kernel@vger.kernel.org>, Ihno Krumreich <ihno@suse.de>,
	Sven Dietrich <sdietrich@suse.de>, Daniel Gollub <dgollub@suse.de>,
	Felix Foerster <ffoerster@suse.de>
References: <12131949173532-git-send-email-sassmann@suse.de> <20080618115819.GA13714@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080618115819.GA13714@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-Jun-08, Ingo Molnar wrote:
> 
> * Stefan Assmann <sassmann@suse.de> wrote:
> 
> > These patches are against linux-2.6-tip, auto-x86-next.
> > 
> > The AMD/ATI and Broadcomm patches are not included yet, we're working 
> > on getting things ready for submission.
> > 
> > The patch for the bootirqquirk= parameter will be released later.
> 
> applied, thanks Stefan. I have created a new 

Cool. :)

> tip/x86/pci-ioapic-boot-irq-quirks topic branch for this. Lets see how 
> these changes work out in practice.

Thanks for creating the branch.

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

