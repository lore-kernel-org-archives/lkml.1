Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYGESxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYGESxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 14:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYGESxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 14:53:11 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33008 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYGESxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 14:53:10 -0400
Date: Sat, 5 Jul 2008 12:52:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@medozas.de>,
       Andrew Morton <akpm@linux-foundation.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>, linux-ia64@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: the printk problem
Message-ID: <20080705185253.GQ14894@parisc-linux.org>
References: <20080705125230.GA20166@damson.getinternet.no> <alpine.LFD.1.10.0807051045520.2815@woody.linux-foundation.org> <19f34abd0807051141h4ccfd0ar28660199f2bbf81f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807051141h4ccfd0ar28660199f2bbf81f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 08:41:39PM +0200, Vegard Nossum wrote:
> Single letters are bad because it hurts readability and limits the
> usefulness of the extension.</MHO>

I think you need a little warning noise that goes off in your head that
means "I might be overdesigning this".  Linus' code is elegant and
solves a problem nicely.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
