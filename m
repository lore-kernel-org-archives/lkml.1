Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZL3U1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZL3U1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbZL3U1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:27:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbZL3U1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:27:45 -0500
Date: Wed, 30 Dec 2009 12:27:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yuhong Bao <yuhongbao_386@hotmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Happy birthday Linus!
In-Reply-To: <SNT125-W13609FA0551FB1FDE1FD4BC37A0@phx.gbl>
Message-ID: <alpine.LFD.2.00.0912301226070.11961@localhost.localdomain>
References: <SNT125-W13609FA0551FB1FDE1FD4BC37A0@phx.gbl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Dec 2009, Yuhong Bao wrote:
>
> BTW, I wonder, did you get a 387-compatible coprocessor later?

Yes, I did. In fact, I bought one purely for Linux development, so that I 
could test the code to do i387 error handling (which is non-trivial, 
because an IBM PC/AT hooks up the i387 in a non-standard way - not the way 
Intel designed it directly to the CPU, but instead through the interrupt 
controller)

		Linus
