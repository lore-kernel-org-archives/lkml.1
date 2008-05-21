Return-Path: <linux-kernel-owner+w=401wt.eu-S932916AbYEUKmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916AbYEUKmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 06:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932922AbYEUKmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 06:42:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:35309 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610AbYEUKlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 06:41:50 -0400
Date: Wed, 21 May 2008 12:41:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tracking and crediting bug reporters
Message-ID: <20080521104145.GB4948@ucw.cz>
References: <4388.1210613272@vena.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4388.1210613272@vena.lwn.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> So here's what we would like to try instead.  Whenever somebody sends up a
> patch fixing a reported bug, the name of the person who reported the bug
> would be immortalized with this tag:
> 
> 	Reported-by: A. Bug Reporter <email@goes.here>
> 
> In particular, reporters who work with the developers toward the resolution
> of the bug should be thanked in this way.  If we wanted to take things

I believe we have enough tags already. Plus, if the reporter really
works with the developer till the end, there's already accepter
Tested-by: flag, right?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
