Return-Path: <linux-kernel-owner+w=401wt.eu-S1761208AbYENOmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761208AbYENOmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbYENOmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:42:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57740 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYENOmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:42:24 -0400
Date: Wed, 14 May 2008 16:42:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Yan <rottled@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Comprehensive list of kernel self-modifications?
Message-ID: <20080514143526.GA6260@ucw.cz>
References: <54b90fdf0805011246v64d28c7ao8eb848419890d20a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54b90fdf0805011246v64d28c7ao8eb848419890d20a@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

> I have been working on verifying kernel integrity and am trying to
> differentiate
> between vmlinux image on disk and the kernel loaded into memory. I understand
>  that the kernel modifies itself (on x86 at least) during at least a few points:

This should go into Doc*/ somewhere. Self-modifying code just loves
provoking cpu bugs...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
