Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYLKIlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYLKIlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 03:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYLKIlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 03:41:04 -0500
Received: from 8bytes.org ([88.198.83.132]:51417 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYLKIlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 03:41:02 -0500
Date: Thu, 11 Dec 2008 09:40:58 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081211084058.GE24323@8bytes.org>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 05:04:39PM -0800, Linus Torvalds wrote:
> 
>  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
> 
>      I like this, because alledgely people are debugging things, and we'd 
>      get a more stable 2.6.28.
>

I'll vote for a. An open merge window over the holidays possible results
in needless stresses for the developers at a time which some of them
want to use otherwise. Or if any merge introduces bad bugs and the
developers that can fix it are on xmax vacation we may end up with an
unusable upstream tree for a week or so. Same with merge conflicts.
So, I'd suggest to wait until everybody is back to work until opening
the merge window.

Joerg

