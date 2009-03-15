Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbZCOVTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbZCOVTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 17:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZCOVTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 17:19:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58236 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbZCOVTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 17:19:00 -0400
Date: Sun, 15 Mar 2009 22:18:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: jffs2 and kernel config for SDHC Memory Cards
Message-ID: <20090315211839.GD1395@ucw.cz>
References: <49B127AB.6070202@asyr.hopto.org> <49B12B71.7030300@asyr.hopto.org> <20090306182425.GB28349@silver.sucs.org> <49B18679.4030504@asyr.hopto.org> <20090306225746.GB25593@silver.sucs.org> <49B2A7F0.1090101@asyr.hopto.org> <20090310112355.GF1337@ucw.cz> <49B6E443.6060205@asyr.hopto.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B6E443.6060205@asyr.hopto.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-03-11 00:05:55, Thanasis wrote:
> on 03/10/2009 01:23 PM Pavel Machek wrote the following:
> 
> > Well, maybe  ext2 is _best_ choice, but it is not good one. It will
> > loose data on sudden powerdowns...
> > 
> > See
> > 
> > (english) http://www.livejournal.com/~pavelmachek
> > 
> > entry 'evil little cards'.
> 
> My problem is not a sudden power failure, which is unlikely, because
> it's a netbook with the battery always on, but from accidentally
> ejecting the one card that protrudes on the right hand side (the other
> on the left side doesn't). I have already done it twice, and was lucky
> to recover with fsck...

hp2133? :-). I lost filesystem there, twice... tytso's suggestion was
to use sticky tape to make sure card stays in; and that's
unfortunately the only feasible solution for now. 

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
