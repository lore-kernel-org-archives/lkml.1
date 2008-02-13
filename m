Return-Path: <linux-kernel-owner+w=401wt.eu-S933178AbYBMRus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178AbYBMRus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbYBMRuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:50:40 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46049 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbYBMRuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:50:40 -0500
Date: Wed, 13 Feb 2008 18:50:46 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix up parse error in linker script
Message-ID: <20080213175046.GC12259@uranus.ravnborg.org>
References: <20080213161008.8791.57543.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213161008.8791.57543.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 04:10:08PM +0000, David Howells wrote:
> Fix up parse error in FRV linker script, presumably introduced through changes
> to the INIT_TEXT and EXIT_TEXT macros.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

My bad - sorry!

	Sam
