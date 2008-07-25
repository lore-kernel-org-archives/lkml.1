Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYGYPlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYGYPlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYGYPk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:40:56 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51410 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYGYPk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:40:56 -0400
Date: Fri, 25 Jul 2008 09:40:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Oops in sched_mc_power_savings_store
Message-ID: <20080725154039.GA17093@parisc-linux.org>
References: <20080724115121.GA28269@parisc-linux.org> <20080724200730.GF20882@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724200730.GF20882@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 10:07:30PM +0200, Andi Kleen wrote:
> Seems like a latent problem. The attributes were just declared wrong.
> Longer term we should probably add the sysdev attributes to the class
> too, but right now here's a minimal fix. Does it solve your problem?

I got discnnected and made the equivalent changes myself.  Yes, it fixes
the problem.  Thanks!

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
