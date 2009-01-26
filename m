Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbZAZOmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbZAZOmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 09:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZAZOmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 09:42:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48631 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZAZOmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 09:42:01 -0500
Date: Mon, 26 Jan 2009 15:42:00 +0100
From: Pavel Machek <pavel@suse.cz>
To: ?ric Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] lis3lv02d: add support for various laptop models
Message-ID: <20090126144200.GA11531@atrey.karlin.mff.cuni.cz>
References: <497D01CA.9040601@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497D01CA.9040601@tremplin-utc.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Here is a series of patches to add knowledge about the axes of various
> HP laptops supported by lis3lv02d/hp_accel, received from owners of
> those laptops. The laptops are already detected, but these patches allow
> to standardize the reported data with the physical movement of the laptop.
> 
> These are safe patches, allowing better hardware support, so it would be
> great if they were accepted for 2.6.29 :-)

They look good to me.

Acked-by: Pavel Machek <pavel@suse.cz>

I'll have patch to support hp 2140, soon. Also.. I'd still like some
testing of the freefall feature.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
