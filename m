Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392Ab0ANVDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0ANVDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498Ab0ANVDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:03:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56231 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab0ANVDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:03:47 -0500
Date: Thu, 14 Jan 2010 22:03:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, Jaya Kumar <jayakumar.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, felipe.balbi@nokia.com,
       linux-fbdev@vger.kernel.org, krzysztof.h1@wp.pl,
       Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
       Oliver Neukum <oliver@neukum.org>, linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Best way to post Logitech G13 driver 0.0.4?
Message-ID: <20100114210339.GA16205@elf.ucw.cz>
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>
 <45a44e481001071832q40d6f913w2ccf89c4c45a692a@mail.gmail.com>
 <5370b38ca0c149470c0e364627c56ee4.squirrel@intranet.cs.nmsu.edu>
 <alpine.LNX.2.00.1001091441180.7275@pobox.suse.cz>
 <cf0603d7c734f836f0b4a64815d649ae.squirrel@intranet.cs.nmsu.edu>
 <fbd89f64a86fc72184658fe9b27509f3.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbd89f64a86fc72184658fe9b27509f3.squirrel@intranet.cs.nmsu.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-01-14 13:50:49, Rick L. Vinyard, Jr. wrote:
> What would be the best way to post 0.0.4 of the driver; as a diff against
> the previous 0.0.3 patch to emphasize the changes or as a diff against the
> torvalds tree to show the patch in its entirety?

Diff against linus tree. If you want to be fancy, make it series with
first patch adding input functionality, second fbcon output on top of
that, third led interface, etc.
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
