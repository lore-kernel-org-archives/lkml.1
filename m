Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYJXRQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYJXRQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYJXRQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:16:19 -0400
Received: from h4.dl5rb.org.uk ([81.2.74.4]:52810 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753219AbYJXRQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:16:18 -0400
Date: Fri, 24 Oct 2008 18:16:05 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Florian Fainelli <florian@openwrt.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mips/pci/fixup-rc32434.c must #include
	<asm/mach-rc32434/irq.h>
Message-ID: <20081024171605.GD25297@linux-mips.org>
References: <20081012130135.GK31153@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081012130135.GK31153@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 04:01:35PM +0300, Adrian Bunk wrote:

Thanks, applied.

  Ralf
