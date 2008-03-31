Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbYCaApo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbYCaApo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 20:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYCaApk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 20:45:40 -0400
Received: from ozlabs.org ([203.10.76.45]:53295 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbYCaApk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 20:45:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18416.13294.32343.345798@cargo.ozlabs.ibm.com>
Date: Mon, 31 Mar 2008 11:44:30 +1100
From: Paul Mackerras <paulus@samba.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] powerpc: remove the non-functional PPC_PREP bits
In-Reply-To: <20080330224012.GD28445@cs181133002.pp.htv.fi>
References: <20080330224012.GD28445@cs181133002.pp.htv.fi>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk writes:

> Back in November 2005, the PPC_PREP bits under arch/powerpc/ were marked 
> as BROKEN due to not being working.
> 
> It doesn't seem to make much sense to keep this rudimentary support even 
> longer.

NAK - I have some patches that get ARCH=powerpc working on at least
some PRePs, and I plan to get them in before arch/ppc goes away.

Paul.
