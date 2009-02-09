Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZBIJ6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZBIJ6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZBIJ6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:58:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33854 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZBIJ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:58:04 -0500
Date: Mon, 9 Feb 2009 10:58:03 +0100
From: Pavel Machek <pavel@suse.cz>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: ?ric Piel <eric.piel@tremplin-utc.net>, linux-kernel@vger.kernel.org,
       Palatis Tseng <palatis@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
Message-ID: <20090209095803.GD4358@atrey.karlin.mff.cuni.cz>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com> <498D9F02.9000107@tremplin-utc.net> <cb7bb73a0902071559w70b3367el9471db894872257f@mail.gmail.com> <20090209094748.GC4358@atrey.karlin.mff.cuni.cz> <cb7bb73a0902090153q30a5337bj45d41a3e3919e189@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb7bb73a0902090153q30a5337bj45d41a3e3919e189@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2009/2/9 Pavel Machek <pavel@suse.cz>:
> > Ok, at my machine it fluctuates around 1K when sitting on the desk,
> > and maximum range is about 13-15K. So your values seem little too noisy.
> 
> I suspected as much. Do you think this is a hardware problem, or
> something that can be worked around in software? Or maybe I just leave
> in a very shaky neighborohood (although there's little or no car
> traffic around here) ...

I'd say that the driver is way too new to suspect hardware
problems. Could you try the new version from -mm? It does very minimum
setup, as recommended by HP...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
