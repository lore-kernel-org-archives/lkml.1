Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbYGFKDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbYGFKDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 06:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbYGFKDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 06:03:24 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:21390 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822AbYGFKDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 06:03:23 -0400
Date: Sun, 6 Jul 2008 12:03:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc9
Message-ID: <20080706120312.2ced86ab@hyperion.delvare>
In-Reply-To: <alpine.LFD.1.10.0807051718470.3016@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807051557500.3016@woody.linux-foundation.org>
	<f31074112h7jusi98q1a7ln3g2nhi6k5ko@4ax.com>
	<alpine.LFD.1.10.0807051718470.3016@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Grant,

On Sat, 5 Jul 2008 17:19:27 -0700 (PDT), Linus Torvalds wrote:
>
> On Sun, 6 Jul 2008, Grant Coady wrote:
> > 
> > Noticed the stale LATEST-IS-* entries no longer being removed at:
> 
> Heh. They were never removed automatically, it requires somebody to 
> remember to remove the old ones. Which I obviously haven't been doing 
> lately.
> 
> Should be fixed now.

What about just getting rid of these files? I fail to see what purpose
they are serving (especially given how badly maintained they are.)

-- 
Jean Delvare
