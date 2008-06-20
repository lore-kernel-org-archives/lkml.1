Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbYFTUKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbYFTUKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYFTUKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:10:40 -0400
Received: from vena.lwn.net ([206.168.112.25]:37965 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbYFTUKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:10:39 -0400
Date: Fri, 20 Jun 2008 14:10:37 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: bkl-removal: drivers/firewire and drivers/ieee1394 patches can
 be reverted/ dropped
Message-ID: <20080620141037.0012a200@bike.lwn.net>
In-Reply-To: <tkrat.08d683698d08913b@s5r6.in-berlin.de>
References: <tkrat.08d683698d08913b@s5r6.in-berlin.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 22:17:49 +0200 (CEST)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> please revert commits
> 
> "firewire: cdev lock_kernel() pushdown"
> aabbc0e478bf1e82e7f4a9ec61abb8a1a259175b
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=aabbc0e478bf1e82e7f4a9ec61abb8a1a259175b
> 
> "ieee1394: cdev lock_kernel() pushdown"
> 8fff9d8cda2b288231fd100333fed26b9bb2042f
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=8fff9d8cda2b288231fd100333fed26b9bb2042f
> 
> and drop them before mainline submission.

Better late than never - those commits are now history.  Thanks for
looking at the code.

jon
