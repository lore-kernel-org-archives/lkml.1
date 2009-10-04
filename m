Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbZJDKX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbZJDKX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 06:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZJDKX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 06:23:59 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:51250 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZJDKX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 06:23:58 -0400
Date: Sun, 4 Oct 2009 14:23:20 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.com>
Subject: Re: [PATCH] connector: Allow permission checking in the receiver callbacks
Message-ID: <20091004102319.GA2569@ioremap.net>
References: <1254235692-1631-1-git-send-email-philipp.reisner@linbit.com> <20090930112057.GA15150@ioremap.net> <20090930132034.GE8032@barkeeper1-xen.linbit> <20090930192928.GA1315@ioremap.net> <20091001080152.GA8018@barkeeper1-xen.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001080152.GA8018@barkeeper1-xen.linbit>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, Oct 01, 2009 at 10:01:52AM +0200, Lars Ellenberg (lars.ellenberg@linbit.com) wrote:
> Please correct me if I'm wrong.

You are right, and I did not argue that patchset is wrong. I just did
not mark it as bugfix, since there were no seriously affected users
(including vesa). But if you push DM changes, which are affected, then
this patchset must be pushed first of course.
Iff DM changes are about to be submitted in the next window, I see no
problems postponing this patchset either.

-- 
	Evgeniy Polyakov
