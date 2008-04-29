Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYD2WAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYD2WAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYD2WAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:00:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbYD2WAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:00:30 -0400
Date: Tue, 29 Apr 2008 14:59:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCHES] V4L/DVB updates and fixes for 2.6.26
In-Reply-To: <20080429185009.716c3284@gaivota>
Message-ID: <alpine.LFD.1.10.0804291457030.2997@woody.linux-foundation.org>
References: <20080429185009.716c3284@gaivota>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Apr 2008, Mauro Carvalho Chehab wrote:
> 
> Notice: the diffstat is very big, due to the "mv" operations.

No, the diffstat is big due to the new cx18 driver. The mv's are almost 
all just pure moves. But that new driver alone is

	47 files changed, 10217 insertions(+), 0 deletions(-)

in a single commit.

Whee...

		Linus
