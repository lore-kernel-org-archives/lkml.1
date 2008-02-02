Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbYBBDmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbYBBDmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 22:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYBBDmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 22:42:03 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46076 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754460AbYBBDmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 22:42:01 -0500
Date: Sat, 2 Feb 2008 14:40:48 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: "Oliver Pinter (Pint?r Oliv?r)" <oliver.pntr@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Greg KH <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [2.6.22.y] {17**/17} - nopage-range-fix.patch (CVE-2008-0007)
 - series for stable kernel #2
In-Reply-To: <6101e8c40802011734k2b4f7c49o980a32fa4a84cd61@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0802021440010.5082@www.l.google.com>
References: <6101e8c40802011734k2b4f7c49o980a32fa4a84cd61@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Feb 2008, Oliver Pinter (Pint?r Oliv?r) wrote:
> 
> Linus it's go or drop it?

I should merge it, I was just a bit bummed that I think the right solution 
is to switch the bitfield meaning around. But the patch is certainly not 
wrong.

		Linus
