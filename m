Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbYCUOFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbYCUOFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYCUOFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:05:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1848 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753922AbYCUOFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:05:36 -0400
Date: Fri, 21 Mar 2008 13:49:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] ddtree: A git kernel tree for storage servers
Message-ID: <20080321124921.GB5331@ucw.cz>
References: <200803190102.25491.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803190102.25491.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-19 00:02:24, Daniel Phillips wrote:
> Hi all,
> 
> I have set up a new git tree to better serve the needs of those 
> interested in advanced storage applications and development.
> 
> This ddtree git repository aims to provide a congenial forum for 
> development of forward looking storage features such as replication and 
> clustering; and to provide improved kernels for those who consider it 
> important that their storage servers run efficiently under heavy load
> without deadlocking.
> 
> What will be in this ddtree?
> 
>   * Block layer deadlock fixes (Status: production)

Sounds like something that should be sent to linus, not hidden in git
tree somewhere?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
