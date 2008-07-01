Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbYGAQcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbYGAQcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYGAQcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:32:12 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61441 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750872AbYGAQcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:32:10 -0400
Date: Tue, 1 Jul 2008 17:31:11 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mpparse: Add a knob to disable IRQ 0 through I/O
 APIC
In-Reply-To: <20080701082742.GA31725@elte.hu>
Message-ID: <Pine.LNX.4.55.0807011727480.6284@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807010041030.30785@cliff.in.clinika.pl>
 <20080701082742.GA31725@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008, Ingo Molnar wrote:

> Note, since mp_config_acpi_legacy_irqs moved to acpi/boot.c i 
> restructured and simplified it slightly - please double-check the form 
> below.

 Thanks for sorting this out -- I guess it's time to get my local tree 
updated.  Your version looks good and should work no worse than mine did 
with my tree (which is an older version of upstream).

  Maciej
