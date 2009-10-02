Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbZJBGtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbZJBGtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 02:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbZJBGtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 02:49:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49701 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbZJBGtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 02:49:21 -0400
Date: Fri, 2 Oct 2009 05:52:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Rafael Wysocki <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Move swap functions to kernel/power/swap.c.
Message-ID: <20091002035208.GA1362@ucw.cz>
References: <4AC036F9.5000003@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC036F9.5000003@crca.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-09-28 14:09:29, Nigel Cunningham wrote:
> Move hibernation code's functions for allocating and freeing swap
> from swsusp.c to swap.c, which is where you'd expect to find them.

Please cc me on hibernation/suspend related patches.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
