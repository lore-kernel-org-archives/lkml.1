Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbXK1KIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbXK1KIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:08:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbXK1KHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:07:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50490 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbXK1KHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:07:54 -0500
Date: Wed, 28 Nov 2007 11:08:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] Hibernation: Fix comment in disk.c
Message-ID: <20071128100829.GA1957@elf.ucw.cz>
References: <200711280113.36941.rjw@sisk.pl> <200711280128.18716.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711280128.18716.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-11-28 01:28:18, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Fix a comment in kernel/power/disk.c so that it doesn't contain lines
> longer that 80 characters.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
