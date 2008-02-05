Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYBERAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYBERAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbYBERAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:00:05 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:35248 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbYBERAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:00:03 -0500
Date: Tue, 5 Feb 2008 11:59:43 -0500
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [-mm Patch] arch/um/kernel/initrd.c: fix a missed conversion specifier
Message-ID: <20080205165943.GA9694@c2.user-mode-linux.org>
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <20080205162557.GC2966@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205162557.GC2966@hacking>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 12:25:57AM +0800, WANG Cong wrote:
> 
> Fix a missed conversion specifier of a printk in
> arch/um/kernel/initrd.c.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Jeff Dike <jdike@karaya.com>

ACK - 2.6.25 material.  Sigh.

		Jeff
