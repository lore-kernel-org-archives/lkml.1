Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZKESUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZKESUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbZKESUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:20:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757577AbZKESUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:20:30 -0500
Date: Thu, 5 Nov 2009 10:19:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Michael Buesch <mb@bu3sch.de>
cc: Jiri Kosina <jkosina@suse.cz>,
       Michael Gilbert <michael.s.gilbert@gmail.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: CVE-2009-2584
In-Reply-To: <200911051847.36103.mb@bu3sch.de>
Message-ID: <alpine.LFD.2.01.0911051018080.31845@localhost.localdomain>
References: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com> <alpine.LFD.2.01.0911050831330.31845@localhost.localdomain> <alpine.LFD.2.01.0911050923580.31845@localhost.localdomain> <200911051847.36103.mb@bu3sch.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Nov 2009, Michael Buesch wrote:
> 
> Looks OK to me. I can't test it however, as I don't own the hardware.

Heh. Even the people who wanted to write exploit examples had the same 
small problem. I doubt it really matters for anybody.

I'm committing it, just because I don't think it can really be any worse 
than the status quo. But I'll happily take further patches, especially 
from anybody who actually has access to the hardware.

		Linus
