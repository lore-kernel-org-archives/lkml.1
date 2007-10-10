Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbXJJITe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbXJJITe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 04:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbXJJIT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 04:19:27 -0400
Received: from styx.suse.cz ([82.119.242.94]:40100 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752505AbXJJIT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 04:19:26 -0400
Date: Wed, 10 Oct 2007 09:55:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: John Zaitseff <J.Zaitseff@zap.org.au>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: Key codes for Microsoft Natural Ergonomic 4000 USB
 keyboard
In-Reply-To: <20071010055958.GA25938@zap.org.au>
Message-ID: <Pine.LNX.4.64.0710100953050.20620@jikos.suse.cz>
References: <20071010055958.GA25938@zap.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007, John Zaitseff wrote:

> The following patch to Linux kernel 2.6.23 enables most of the extra 
> keys found on the Microsoft Natural Ergonomic 4000 USB keyboard.  I had 
> to add one keycode to include/linux/input.h; feel free to reallocate the 
> ID assigned to it (KEY_SPELL).

Hi John,

thanks a lot for the patch! However I think I have already added all the 
needed support for this keyboard. It is currently in my tree, queued until 
Linus opens the merge window for 2.6.24. Please look at 
http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=0f48b3ce23a34dbe70dcd04b4216fbcb965ab906

Commit 945bcc3a in the same branch is also related.

-- 
Jiri Kosina
SUSE Labs
