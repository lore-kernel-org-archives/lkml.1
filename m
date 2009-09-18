Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbZIRTfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbZIRTfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbZIRTfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:35:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59664 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045AbZIRTfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:35:02 -0400
Date: Fri, 18 Sep 2009 20:34:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Fix "W" macro in arch/arm/include/asm/unified.h
Message-ID: <20090918193422.GA6601@n2100.arm.linux.org.uk>
References: <20090917091237.8258.29171.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917091237.8258.29171.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 10:12:37AM +0100, Catalin Marinas wrote:
> From: Alexey Dobriyan <adobriyan@gmail.com>
> 
> Please, fold into 0becb088501886f37ade38762c8eaaf4263572cc
> aka "Thumb-2: Add macros for the unified assembler syntax"

Folding it into that commit is not possible; as such a better patch
description is desirable.
