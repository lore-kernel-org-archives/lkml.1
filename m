Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbYKLWKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbYKLWKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYKLWKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:10:23 -0500
Received: from kroah.org ([198.145.64.141]:55109 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751582AbYKLWKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:10:22 -0500
Date: Wed, 12 Nov 2008 13:58:22 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] w35und: remove rxisr.c as dead code
Message-ID: <20081112215822.GA8156@kroah.com>
References: <1225386296-19632-1-git-send-email-penberg@cs.helsinki.fi> <1225386296-19632-2-git-send-email-penberg@cs.helsinki.fi> <1225386296-19632-3-git-send-email-penberg@cs.helsinki.fi> <1225386296-19632-4-git-send-email-penberg@cs.helsinki.fi> <1225386296-19632-5-git-send-email-penberg@cs.helsinki.fi> <1225386296-19632-6-git-send-email-penberg@cs.helsinki.fi> <1225386296-19632-7-git-send-email-penberg@cs.helsinki.fi> <20081030192903.GM22185@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030192903.GM22185@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 08:29:03PM +0100, Pavel Machek wrote:
> On Thu 2008-10-30 19:04:56, Pekka Enberg wrote:
> > The vRxTimerStart() function is never called nor does the timer do anything
> > useful so remove the code.
> 
> Whole series:
> 
> Acked-by: Pavel Machek <pavel@suse.cz>
> 
> ...and thanks for doing that. The driver really needed it.

I concur, thanks a lot for this work.  I should now be all caught up
with the patches you have sent me.  If I've missed any, please let me
know.

thanks,

greg k-h
