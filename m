Return-Path: <linux-kernel-owner+w=401wt.eu-S1763932AbZFLTDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763932AbZFLTDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763697AbZFLTDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:03:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52968 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763581AbZFLTDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:03:17 -0400
Date: Fri, 12 Jun 2009 20:03:03 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/13] cpumask: Use accessors for cpu_*_mask: arm
Message-ID: <20090612190303.GA7976@flint.arm.linux.org.uk>
References: <20090612133100.765C2DDDA0@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612133100.765C2DDDA0@ozlabs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 10:33:14PM +0930, Rusty Russell wrote:
> Use the accessors rather than frobbing bits directly (the new versions
> are const).

Please check linux-next - there are all kinds of SMP changes currently
queued up in the ARM tree, which include most of the updates for things
like this.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
