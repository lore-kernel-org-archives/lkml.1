Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbYKLBzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbYKLBzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYKLBzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:55:45 -0500
Received: from ozlabs.org ([203.10.76.45]:36547 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbYKLBzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:55:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18714.14081.378730.381602@drongo.ozlabs.ibm.com>
Date: Wed, 12 Nov 2008 12:53:05 +1100
From: Paul Mackerras <paulus@samba.org>
To: Greg KH <greg@kroah.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       linux-kernel Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: Fwd: [PATCH v2][for 2.6.28] powerpc/mpic: Add support for
	MPICs that only support a single CPU destination
In-Reply-To: <20081111211801.GB2497@kroah.com>
References: <1225252899-20752-1-git-send-email-galak@kernel.crashing.org>
	<B48FBC1A-5974-4E68-B34A-39C223328EFF@kernel.crashing.org>
	<20081111211801.GB2497@kroah.com>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH writes:

> > Can you pick this up for stable-2.6.27.
> 
> I don't see this in Linus's tree right now.
> 
> Am I missing it?  Or do you know what the git commit id is?

It's 3c10c9c45e290022ca7d2aa1ad33a0b6ed767520.  I changed the title to
"powerpc/mpic: Fix regression caused by change of default IRQ
affinity" and expanded the patch description to emphasize that it was
fixing a regression rather than just adding a feature.

Paul.
