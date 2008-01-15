Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYAORE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYAORE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYAOREW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:04:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34374 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYAOREV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:04:21 -0500
Date: Tue, 15 Jan 2008 17:02:35 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <adrian.bunk@movial.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [2.6.24 patch] restore ARMv6 OProfile support
Message-ID: <20080115170235.GA19306@flint.arm.linux.org.uk>
References: <20071228195841.GA3945@flint.arm.linux.org.uk> <20080115104526.GA32067@flint.arm.linux.org.uk> <alpine.LFD.1.00.0801150811250.2806@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801150811250.2806@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 08:24:34AM -0800, Linus Torvalds wrote:
> So does something like this work for people?

Just tested it and the right Kconfig symbols get set again - thanks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
