Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYIHSqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYIHSqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYIHSq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:46:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:43812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbYIHSqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:46:25 -0400
Date: Mon, 8 Sep 2008 11:46:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080908114619.741b6786@infradead.org>
In-Reply-To: <48C56D60.7010405@zytor.com>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>
	<alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
	<48C56D60.7010405@zytor.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2008 11:22:24 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> 
> The "ideal" way to do any of this would probably to have checkboxes
> for all the CPUs you want to support and then a drop-down box for the
> CPU to optimize for.  However, the combinatorics of that would be
> horrible, and it would be very unlikely we would avoid bugs.

the ideal case would be "support them all"

the second-most ideal case would be "support all as of <year>" I suppose

a third one for advanced users not distros would be "support only
<vendor>" since that would be the biggest part of code to drop

between models of the same vendor.. not too much to win there.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
