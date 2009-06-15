Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZFOHos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZFOHos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbZFOHok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:44:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58466 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZFOHoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:44:39 -0400
Date: Mon, 15 Jun 2009 08:44:23 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/13] cpumask: Use accessors for cpu_*_mask: arm
Message-ID: <20090615074422.GA2009@flint.arm.linux.org.uk>
References: <20090612133100.765C2DDDA0@ozlabs.org> <20090612190303.GA7976@flint.arm.linux.org.uk> <200906132225.12855.rusty@rustcorp.com.au> <20090613134922.GA23433@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090613134922.GA23433@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 02:49:22PM +0100, Russell King wrote:
> Commit 8266810 "[ARM] smp: fix cpumask usage in ARM SMP code" (in my tree
> since May 17th) fixes some of the areas which your patch touches.  See:
> 
> http://ftp.arm.linux.org.uk/git/gitweb.cgi?p=linux-2.6-arm.git;a=shortlog;h=refs/heads/smp
> 
> I suggest hanging fire on this until the ARM tree is merged into mainline.

... which has now happened.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
