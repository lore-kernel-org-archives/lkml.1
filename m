Return-Path: <linux-kernel-owner+w=401wt.eu-S934213AbYEBV66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934213AbYEBV66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbYEBV6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:58:49 -0400
Received: from lazybastard.de ([212.112.238.170]:58025 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825AbYEBV6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:58:48 -0400
Date: Fri, 2 May 2008 23:58:33 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
Message-ID: <20080502215833.GG24080@logfs.org>
References: <20080502133234.GA24080@logfs.org> <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org> <20080502202151.GB24080@logfs.org> <alpine.LFD.1.10.0805021328200.5994@woody.linux-foundation.org> <20080502213146.GD24080@logfs.org> <alpine.LFD.1.10.0805021438180.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0805021438180.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 14:39:23 -0700, Linus Torvalds wrote:
> 
> Quite frankly, if that's the case, I'd *much* rather see that worked on 
> first, so that there aren't any format changes that are already known to 
> be pending before it even gets merged.
> 
> Would it be at all possible to try to do that, or is it just "too far 
> out"?

Definitely possible.  The last similar change happened in December and
took until March until I ran out of stupid regressions from it.  Most
likely there are still some I just haven't found yet.

The question is when to draw the line and say "This is useful as-is for
a sufficient number of users."  I don't have a good answer to it.  I
certainly expect more changes in the future, including format changes.
And if we wait for them all to happen, it won't get merged this decade.

Not sure.

Jörn

-- 
The only good bug is a dead bug.
-- Starship Troopers
