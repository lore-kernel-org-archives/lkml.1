Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbXKEWQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbXKEWQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXKEWQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:16:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbXKEWQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:16:46 -0500
Date: Mon, 5 Nov 2007 14:16:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.24-rc1
In-Reply-To: <alpine.LFD.0.999.0711051410180.15101@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0711051414120.15101@woody.linux-foundation.org>
References: <20071105215601.GA4612@kroah.com>
 <alpine.LFD.0.999.0711051410180.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Nov 2007, Linus Torvalds wrote:
> 
> This one is bogus:

Side note: I pulled and pushed out, since I assume the *code* is correct, 
but please double-check the commit messages for things like this.

gitk makes it really easy, since it will highlight valid commit ID's. It 
looks lik eyou may have re-ordered the commits or something?

		Linus
