Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYAIW4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYAIW4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYAIW4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:56:44 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50930 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753461AbYAIW4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:56:44 -0500
Date: Wed, 9 Jan 2008 23:48:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [patch 2.6.24-rc7] remove obsolete
	/sys/devices/.../power/state docs
Message-ID: <20080109224830.GA19545@elf.ucw.cz>
References: <200801091212.24386.david-b@pacbell.net> <200801092255.09841.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801092255.09841.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-01-09 22:55:09, Rafael J. Wysocki wrote:
> On Wednesday, 9 of January 2008, David Brownell wrote:
> > The /sys/devices/.../power/state files have been gone for a while
> > now, but I just noticed some documentation that still refers to
> > them.  (Fortunately described as DEPRECATED and WILL REMOVE).
> > 
> > Time to remove that obsolete documentation too ...
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
