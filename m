Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbYFWL0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbYFWL0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYFWL0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:26:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbYFWL0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:26:38 -0400
Date: Mon, 23 Jun 2008 13:26:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [RESEND PATCH 1/3] e1000e: set CONFIG_E1000E=y in x86
	defconfigs
Message-ID: <20080623112618.GC7485@elte.hu>
References: <20080622221916.5907.79563.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622221916.5907.79563.stgit@localhost.localdomain>
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


* Jeff Kirsher <jeffrey.t.kirsher@intel.com> wrote:

> From: Auke Kok <auke-jan.h.kok@intel.com>
> 
> This adds to the already default CONFIG_E1000=y in these files.
> 
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
> 
>  arch/x86/configs/i386_defconfig   |    1 +
>  arch/x86/configs/x86_64_defconfig |    1 +

that is not an e1000 patch but an arch/x86 defconfig patch. NAK on this 
route of patch propagation.

	Ingo
