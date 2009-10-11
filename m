Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbZJKXPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbZJKXPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZJKXPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:15:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644AbZJKXPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:15:14 -0400
Date: Sun, 11 Oct 2009 16:11:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "Theodore Ts'o" <tytso@mit.edu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, linux-ext4@vger.kernel.org
Subject: Re: 2.6.32-rc4: Reported regressions from 2.6.31
In-Reply-To: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
Message-ID: <alpine.LFD.2.01.0910111608490.3438@localhost.localdomain>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 12 Oct 2009, Rafael J. Wysocki wrote:
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14370
> Subject		: ext4 corruptions
> Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
> Date		: 2009-10-09 19:20 (3 days old)
> References	: http://marc.info/?l=linux-kernel&m=125511643504864&w=4
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14354
> Subject		: Bad corruption with 2.6.32-rc1 and upwards
> Submitter	: Holger Freyther <zecke@selfish.org>
> Date		: 2009-10-09 15:42 (3 days old)

These two look like duplicates to me. No?

			Linus
