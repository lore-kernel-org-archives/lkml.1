Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbYGOUPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbYGOUPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbYGOUPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:15:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755231AbYGOUPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:15:42 -0400
Date: Tue, 15 Jul 2008 13:15:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulmck@us.ibm.com,
       a.p.zijlstra@chello.nl, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [git pull] RCU updates for v2.6.27
Message-Id: <20080715131515.ebdc53d8.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151037060.3017@woody.linux-foundation.org>
References: <20080714152045.GA29159@elte.hu>
	<alpine.LFD.1.10.0807151037060.3017@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 10:38:27 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Hmm. I really wanted to wait with kmemcheck, which is huge and I'm not 
> entirely convinced yet.

Any particular concerns?

I haven't looked at it yet, and I wouldn't mind seeing it go past in
changelog+patch form again for reviewing pleasure.

