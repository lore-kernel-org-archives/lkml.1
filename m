Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYG3U4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYG3U4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYG3U4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:56:04 -0400
Received: from vena.lwn.net ([206.168.112.25]:35231 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbYG3U4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:56:03 -0400
Date: Wed, 30 Jul 2008 14:56:00 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Amanda McPherson <amanda@amcpherson.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] A development process document
Message-ID: <20080730145600.7b61a43a@bike.lwn.net>
In-Reply-To: <Pine.LNX.4.64.0807301307060.26427@twin.jikos.cz>
References: <20080729143015.0f79cf37@bike.lwn.net>
	<Pine.LNX.4.64.0807301307060.26427@twin.jikos.cz>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 13:09:13 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On the other hand, the drivers for completely new hardware (that has
> been totally unsupported by the kernel previously, so there is no
> possibility for introducing regressions) are still allowed even after
> -rc1, right? 

Clearly it's been known to happen (can you say GRU?).  But I don't know
that has ever really been adopted as an "official" policy.  My
preference would be to lay down the merge window rules as a fairly firm
thing rather than suggest to people that there might be ways to slip
around them sometimes.  But, certainly, I'm not tied to that if we want
to send a different message.

Thanks,

jon
