Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZLEUou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZLEUou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZLEUos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:44:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191AbZLEUor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:44:47 -0500
Date: Sat, 5 Dec 2009 12:44:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
In-Reply-To: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0912051242460.3649@localhost.localdomain>
References: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Dec 2009, Al Viro wrote:
> 
> [NOTE: the patch series below is not for merge until ACKed by arch maintainers]

Side note - I'd like to get this in early rather than late.

So if some arch maintainer is tardy, I'd rather do the series quickly even 
without an ack. I'd hate to apply this series just days before the merge 
window closes and then have to fix things up. In contrast, applying it 
early (even if that is then followed by "and then have to fix things up") 
is much preferable.

		Linus
