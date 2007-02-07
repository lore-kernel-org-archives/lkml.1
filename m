Return-Path: <linux-kernel-owner+w=401wt.eu-S1161228AbXBGLyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161228AbXBGLyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161234AbXBGLyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:54:12 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2072 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161228AbXBGLyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:54:11 -0500
Date: Wed, 7 Feb 2007 11:54:01 +0000
From: Pavel Machek <pavel@ucw.cz>
To: CIJOML <cijoml@volny.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Some "patch" between 2.6.20-rc7 and 2.6.20-final-vanilla has broken my SWSUSP resume
Message-ID: <20070207115400.GC4481@ucw.cz>
References: <200702051049.49705.cijoml@volny.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702051049.49705.cijoml@volny.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> please take a look at my bugreport. It is very important for me...
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=7936
> 
> Thanks a lot

If it is really caused by difference between -rc7 and -final... then I
guess it is 'git bisect' time...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
