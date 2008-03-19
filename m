Return-Path: <linux-kernel-owner+w=401wt.eu-S935272AbYCSWUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935272AbYCSWUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYCSUxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:53:08 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:43387 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762688AbYCSUxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:53:06 -0400
Date: Wed, 19 Mar 2008 16:06:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, andi@firstfloor.org
Subject: Re: iommu: it could use some documentation
Message-ID: <20080319150638.GB27623@elte.hu>
References: <20080319145811.GA27113@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319145811.GA27113@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2086]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> Fix coding style in pci-dma_64.c and add stubs for documentation. I 
> hope someone fills the rest, I understand maybe off and soft...

thanks Pavel, i've applied your bits. This file could need a ton more 
cleanups.

	Ingo
