Return-Path: <linux-kernel-owner+w=401wt.eu-S1762126AbYGAARy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762126AbYGAARy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 20:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbYGAARp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 20:17:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54157 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbYGAARo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 20:17:44 -0400
Date: Tue, 1 Jul 2008 01:17:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Message-ID: <20080701001727.GA4174@srcf.ucam.org>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assuming it works for Rafael (still haven't had time to pull my nx6125 
out of storage):

Signed-off-by: mjg@redhat.com

-- 
Matthew Garrett | mjg59@srcf.ucam.org
