Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbYDXIJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbYDXIJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 04:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYDXIJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 04:09:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1199 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750841AbYDXIJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 04:09:29 -0400
Date: Thu, 24 Apr 2008 10:09:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH 1/5] Container Freezer: Add TIF_FREEZE flag to all architectures
Message-ID: <20080424080918.GA10867@ucw.cz>
References: <20080424064756.643890130@us.ibm.com> <20080424064756.935832298@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424064756.935832298@us.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-04-23 23:47:57, Matt Helsley wrote:
> This patch is the first step in making the refrigerator() available 
> to all architectures, even for those without power management. 
> 
> The purpose of such a change is to be able to use the refrigerator() 
> in a new control group subsystem which will implement a control group
> freezer.
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> Tested-by: Matt Helsley <matthltc@us.ibm.com>

ACK.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
