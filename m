Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXLVCPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXLVCPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 21:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXLVCPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 21:15:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44398 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbXLVCPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:15:40 -0500
Date: Sat, 22 Dec 2007 03:10:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, bjorn.helgaas@hp.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch 3/3] PCI: use dev_printk in x86 quirk messages
Message-ID: <20071222021046.GA18276@elte.hu>
References: <20071217210937.103111394@ldl.fc.hp.com> <20071217211337.545932066@ldl.fc.hp.com> <20071218135801.GB17470@elte.hu> <20071221134735.1e0066c9.akpm@linux-foundation.org> <20071221222956.GB24478@suse.de> <20071221224053.GA23289@elte.hu> <20071221230618.GA16365@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221230618.GA16365@suse.de>
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


* Greg KH <gregkh@suse.de> wrote:

> How about you drop this one patch, and I'll keep it, as it goes along 
> with the other 2 patches in his series, and I'll make sure to check if 
> I have future pci quirk patches that affect the x86/ directory.
> 
> Sound reasonable?

sure enough - dropped.

	Ingo
