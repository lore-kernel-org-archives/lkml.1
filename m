Return-Path: <linux-kernel-owner+w=401wt.eu-S1764568AbYHFJlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764568AbYHFJlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbYHFJlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:41:35 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:33087 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbYHFJle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:41:34 -0400
Date: Wed, 6 Aug 2008 11:41:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [GIT PATCH] hwmon updates against v2.6.26
Message-ID: <20080806114121.377e6628@hyperion.delvare>
In-Reply-To: <489967E4.9060002@hhs.nl>
References: <20080801041026.GI3375@mars.solarsys.private>
	<20080806103903.6b9eec76@hyperion.delvare>
	<489967E4.9060002@hhs.nl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008 10:59:16 +0200, Hans de Goede wrote:
> Jean Delvare wrote:
> > I have a number of hwmon patches in my local kernel tree which I wrote
> > and that have been reviewed by a trusted developer, or that have been
> > posted to the lm-sensors list and that I have reviewed. I consider
> > these ready to go upstream. I plan to gather these into a public tree
> > and push them to Linus today or tomorrow. In the future, I will
> > probably have such a tree available to be included in linux-next.
> 
> I too don't want to see any patches get dropped, so I'll try to step up a 
> little with regards to reviewing hwmon patches, I would be grateful if you 
> could incorporate any patches Acked by me in said tree. Esp since my git-fu 
> isn't all that good.

Will do. Note that I'm really using quilt, not git, to push patches to
linux-next. I only use git to push patches to Linus once in a while.

-- 
Jean Delvare
